"""Black-box checks for the incremental Typst build watcher."""

import os
import shutil
import signal
import stat
import subprocess
import sys
import tempfile
import time
import unittest
from pathlib import Path


BUILD_SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "build.py"
TIMEOUT = 8.0


class WatchTests(unittest.TestCase):
    def make_project(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        root = Path(temporary.name)
        repo = root / "project"
        (repo / "scripts").mkdir(parents=True)
        shutil.copy2(BUILD_SCRIPT, repo / "scripts" / "build.py")
        (repo / "main.typ").write_text("= 目录\n==& 初始标题\n", encoding="utf-8")
        return root, repo

    def start_watch(self, root, repo, *args, env=None):
        log_path = root / "watch.log"
        log_file = log_path.open("wb")
        command = [sys.executable, "-u", str(repo / "scripts" / "build.py"), "--watch", *args]
        process = subprocess.Popen(
            command,
            cwd=repo,
            stdout=log_file,
            stderr=subprocess.STDOUT,
            env=env,
        )
        self.addCleanup(self.stop_watch, process, log_file)
        return process, log_path

    @staticmethod
    def stop_watch(process, log_file):
        if process.poll() is None:
            process.send_signal(signal.SIGINT)
            try:
                process.wait(timeout=3)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait(timeout=3)
        log_file.close()

    @staticmethod
    def log_text(path):
        return path.read_text(encoding="utf-8", errors="replace")

    def wait_until(self, process, log_path, condition, label):
        deadline = time.monotonic() + TIMEOUT
        while time.monotonic() < deadline:
            if condition():
                return
            if process.poll() is not None:
                self.fail(
                    f"watch exited with {process.returncode} before {label}:\n"
                    + self.log_text(log_path)
                )
            time.sleep(0.05)
        self.fail(f"timed out waiting for {label}:\n" + self.log_text(log_path))

    def test_prepare_only_watch_syncs_changes_without_self_triggering(self):
        root, repo = self.make_project()
        main = repo / "main.typ"
        keep = repo / "sections" / "keep.typ"
        keep.parent.mkdir()
        keep.write_text("== 保持不变\n", encoding="utf-8")
        process, log_path = self.start_watch(root, repo, "--prepare-only")
        stage = repo / "dist" / "_typst"
        staged_main = stage / "main.typ"
        staged_keep = stage / "sections" / "keep.typ"

        def ready_count():
            return self.log_text(log_path).count("[build] ready")

        self.wait_until(
            process, log_path,
            lambda: ready_count() >= 1 and staged_main.exists() and staged_keep.exists(),
            "initial prepared tree",
        )
        self.assertIn("== 初始标题\n", staged_main.read_text(encoding="utf-8"))
        self.assertIn("#set heading(outlined: false)", staged_main.read_text(encoding="utf-8"))
        self.assertEqual(main.read_text(encoding="utf-8"), "= 目录\n==& 初始标题\n")
        keep_mtime = staged_keep.stat().st_mtime_ns

        previous_ready = ready_count()
        main.write_text("= 目录\n== 去掉标记的标题\n", encoding="utf-8")
        self.wait_until(
            process, log_path,
            lambda: ready_count() > previous_ready
            and staged_main.read_text(encoding="utf-8") == main.read_text(encoding="utf-8"),
            "heading after removing ampersand",
        )

        previous_ready = ready_count()
        main.write_text("= 目录\n==& 再次添加标记的标题\n", encoding="utf-8")
        self.wait_until(
            process, log_path,
            lambda: ready_count() > previous_ready
            and "== 再次添加标记的标题\n" in staged_main.read_text(encoding="utf-8")
            and "#set heading(outlined: false)" in staged_main.read_text(encoding="utf-8"),
            "heading after adding ampersand",
        )
        self.assertEqual(staged_keep.stat().st_mtime_ns, keep_mtime)
        self.assertIn("==& 再次添加标记的标题", main.read_text(encoding="utf-8"))

        asset = repo / "assets" / "new.bin"
        asset.parent.mkdir()
        previous_ready = ready_count()
        asset.write_bytes(b"new resource\x00")
        staged_asset = stage / "assets" / "new.bin"
        self.wait_until(
            process, log_path,
            lambda: ready_count() > previous_ready
            and staged_asset.exists() and staged_asset.read_bytes() == asset.read_bytes(),
            "new resource in prepared tree",
        )

        previous_ready = ready_count()
        asset.unlink()
        self.wait_until(
            process, log_path,
            lambda: ready_count() > previous_ready and not staged_asset.exists(),
            "deleted resource removed from prepared tree",
        )

        builds_before = self.log_text(log_path).count("[build] building")
        staged_main.write_text("mirror-only edit\n", encoding="utf-8")
        (repo / "dist" / "xcpc-codebook.pdf").write_bytes(b"output-only edit")
        time.sleep(1.3)  # More than two 0.5 s watch polls.
        self.assertIsNone(process.poll(), self.log_text(log_path))
        self.assertEqual(
            self.log_text(log_path).count("[build] building"), builds_before,
            "generated mirror/output changes must not trigger another build",
        )

    def test_failed_compile_recovers_and_sigint_stops_watch(self):
        root, repo = self.make_project()
        fail_flag = root / "fail-compile"
        fail_flag.touch()
        fake_typst = repo / "scripts" / "fake-typst"
        fake_typst.write_text(
            "#!/usr/bin/env python3\n"
            "import os\n"
            "from pathlib import Path\n"
            "import sys\n"
            "if Path(os.environ['FAKE_TYPST_FAIL_FLAG']).exists():\n"
            "    print('FAKE_TYPST_FAILURE', file=sys.stderr, flush=True)\n"
            "    raise SystemExit(7)\n"
            "source = Path(sys.argv[-2])\n"
            "output = Path(sys.argv[-1])\n"
            "output.parent.mkdir(parents=True, exist_ok=True)\n"
            "output.write_text(source.read_text(encoding='utf-8'), encoding='utf-8')\n",
            encoding="utf-8",
        )
        fake_typst.chmod(fake_typst.stat().st_mode | stat.S_IXUSR)
        environment = os.environ.copy()
        environment["FAKE_TYPST_FAIL_FLAG"] = str(fail_flag)
        process, log_path = self.start_watch(
            root, repo, "--typst", str(fake_typst), env=environment,
        )

        self.wait_until(
            process, log_path,
            lambda: "FAKE_TYPST_FAILURE" in self.log_text(log_path),
            "initial fake Typst failure",
        )
        self.assertIsNone(process.poll(), self.log_text(log_path))
        initial_builds = self.log_text(log_path).count("[build] building")
        time.sleep(1.1)
        self.assertEqual(self.log_text(log_path).count("[build] building"), initial_builds)

        fail_flag.unlink()  # Outside the watched project; the source edit triggers retry.
        (repo / "main.typ").write_text("= 目录\n==& 修复后的标题\n", encoding="utf-8")
        output = repo / "dist" / "xcpc-codebook.pdf"
        self.wait_until(
            process, log_path,
            lambda: "[build] ready" in self.log_text(log_path)
            and output.exists()
            and "== 修复后的标题" in output.read_text(encoding="utf-8"),
            "successful retry after source edit",
        )
        self.assertIsNone(process.poll(), self.log_text(log_path))

        process.send_signal(signal.SIGINT)
        process.wait(timeout=3)
        self.assertIn(process.returncode, (0, 130), self.log_text(log_path))
        self.assertNotIn("Traceback", self.log_text(log_path))


if __name__ == "__main__":
    unittest.main()
