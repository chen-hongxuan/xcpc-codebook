#!/usr/bin/env python3
"""Build the codebook from a prepared copy of its Typst sources."""

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path


EXCLUDED = {
    ".git", "dist", "backup", "fonts", ".obsidian", ".vscode",
    "scripts", "__pycache__",
}
MARKED_HEADING = re.compile(r"^([ \t]*)(=+)&(?=[ \t]|$)")
CODE_STATEMENT = re.compile(r"(?:let|show|set|import|include|for|while|if|return)\b")


def _advance_state(line, state):
    """Track enough Typst syntax to distinguish markup from code and math."""
    raw_ticks, comment_depth, quote_ticks, contexts = state
    i = 0
    while i < len(line):
        if raw_ticks:
            if line[i] == "`":
                j = i + 1
                while j < len(line) and line[j] == "`":
                    j += 1
                if j - i == raw_ticks:
                    raw_ticks = 0
                i = j
            else:
                i += 1
        elif comment_depth:
            if line.startswith("/*", i):
                comment_depth += 1
                i += 2
            elif line.startswith("*/", i):
                comment_depth -= 1
                i += 2
            else:
                i += 1
        elif quote_ticks:
            if line[i] == "\\":
                i += 2
            elif line.startswith('"' * quote_ticks, i):
                i += quote_ticks
                quote_ticks = 0
            else:
                i += 1
        elif line.startswith("//", i):
            break
        elif line.startswith("/*", i):
            comment_depth += 1
            i += 2
        elif line[i] == "\\":
            i += 2
        elif line[i] == "`":
            j = i + 1
            while j < len(line) and line[j] == "`":
                j += 1
            raw_ticks = j - i
            i = j
        else:
            mode, closing = contexts[-1]
            ch = line[i]
            if mode == "markup":
                if ch == "]" and closing == "]":
                    contexts.pop()
                    i += 1
                elif ch == "[" and closing == "]":
                    contexts.append(("markup", "]"))
                    i += 1
                elif ch == "#":
                    if line.startswith("#[", i):
                        contexts.append(("markup", "]"))
                        i += 2
                    else:
                        kind = "statement" if CODE_STATEMENT.match(line, i + 1) else "inline"
                        contexts.append(("code", kind))
                        i += 1
                elif ch == "$":
                    contexts.append(("math", "$"))
                    i += 1
                else:
                    i += 1  # Ordinary prose quotes have no lexical state.
            elif mode == "math":
                if ch == "$":
                    contexts.pop()
                    i += 1
                elif ch == '"':
                    quote_ticks = 3 if line.startswith('"""', i) else 1
                    i += quote_ticks
                elif ch == "#":
                    contexts.append(("code", "inline"))
                    i += 1
                else:
                    i += 1
            elif closing == "inline" and (ch.isspace() or ch in '#],;!?"'):
                contexts.pop()
            elif ch == closing and closing in (")", "}"):
                contexts.pop()
                i += 1
            elif ch == '"':
                quote_ticks = 3 if line.startswith('"""', i) else 1
                i += quote_ticks
            elif ch == "(":
                contexts.append(("code", ")"))
                i += 1
            elif ch == "{":
                contexts.append(("code", "}"))
                i += 1
            elif ch == "[":
                contexts.append(("markup", "]"))
                i += 1
            elif ch == "$":
                contexts.append(("math", "$"))
                i += 1
            else:
                i += 1

    if not (raw_ticks or comment_depth or quote_ticks):
        while len(contexts) > 1 and contexts[-1][1] in ("inline", "statement"):
            if contexts[-1][1] == "statement" and line.rstrip().endswith(("=", ",", ":", "\\")):
                break
            contexts.pop()
    return raw_ticks, comment_depth, quote_ticks, contexts


def transform(source):
    """Hide ``==& Title`` headings from the outline, preserving their markup."""
    output = []
    state = (0, 0, 0, [("markup", None)])
    pending_reset = None
    for line in source.splitlines(keepends=True):
        if line.endswith("\r\n"):
            body, ending = line[:-2], "\r\n"
        elif line.endswith(("\n", "\r")):
            body, ending = line[:-1], line[-1]
        else:
            body, ending = line, ""

        raw_ticks, comment_depth, quote_ticks, contexts = state
        if not (raw_ticks or comment_depth or quote_ticks) and contexts[-1][0] == "markup":
            match = MARKED_HEADING.match(body)
            if match:
                indent = match.group(1)
                title = body[:match.end(2)] + body[match.end():]
                if len(body) == match.end():
                    title += " "
                separator = ending or "\n"
                output.extend((
                    indent + "#set heading(outlined: false)" + separator,
                    title + separator,
                ))
                state = _advance_state(body, state)
                raw_ticks, comment_depth, quote_ticks, contexts = state
                if not (raw_ticks or comment_depth or quote_ticks) and contexts[-1][0] == "markup":
                    output.append(indent + "#set heading(outlined: true)" + ending)
                else:
                    pending_reset = indent
                continue

        output.append(line)
        state = _advance_state(body, state)
        raw_ticks, comment_depth, quote_ticks, contexts = state
        if pending_reset is not None and not (raw_ticks or comment_depth or quote_ticks) and contexts[-1][0] == "markup":
            if not ending:
                output.append("\n")
            output.append(pending_reset + "#set heading(outlined: true)" + ending)
            pending_reset = None
    return "".join(output)


def _source_tree(repo, output=None):
    """List source directories and files, excluding build products."""
    repo = Path(repo).resolve()
    output = Path(output).resolve() if output is not None else None
    directories, files = {Path(".")}, {}
    for current, names, filenames in os.walk(repo):
        current = Path(current)
        relative = current.relative_to(repo)
        directories.add(relative)
        for name in list(names):
            path = current / name
            if name in EXCLUDED:
                names.remove(name)
            elif path.is_symlink():
                names.remove(name)
                files[relative / name] = path
        for name in filenames:
            if name in EXCLUDED or relative == Path(".") and name.lower().endswith(".pdf"):
                continue
            path = current / name
            if output is None or path.resolve() != output:
                files[relative / name] = path
    return directories, files


def source_snapshot(repo, output=None):
    """Record file names, nanosecond mtimes, and sizes for polling."""
    _, files = _source_tree(repo, output)
    snapshot = {}
    for name, path in files.items():
        stat = path.lstat()
        snapshot[name] = (stat.st_mtime_ns, stat.st_size)
    return snapshot


def _remove(path):
    if path.is_dir() and not path.is_symlink():
        shutil.rmtree(path)
    else:
        path.unlink()


def _sync_file(source, target):
    """Copy changed content; write Typst files through an atomic rename."""
    if source.is_symlink() and source.suffix != ".typ":
        link = os.readlink(source)
        if target.is_symlink() and os.readlink(target) == link:
            return
        if target.exists() or target.is_symlink():
            _remove(target)
        target.symlink_to(link, target_is_directory=source.is_dir())
        return

    data = source.read_bytes()
    if source.suffix == ".typ":
        data = transform(data.decode("utf-8")).encode("utf-8")
    if target.is_file() and not target.is_symlink() and target.read_bytes() == data:
        return
    fd, temporary = tempfile.mkstemp(prefix=f".{target.name}.", dir=target.parent)
    try:
        with os.fdopen(fd, "wb") as stream:
            stream.write(data)
        shutil.copymode(source, temporary)
        os.replace(temporary, target)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def prepare(repo, output=None):
    """Incrementally synchronize a path-compatible Typst source tree."""
    repo = Path(repo).resolve()
    stage = repo / "dist" / "_typst"
    if stage.is_symlink():
        raise OSError(f"refusing to replace symlink: {stage}")
    stage.mkdir(parents=True, exist_ok=True)
    directories, files = _source_tree(repo, output)

    for current, names, filenames in os.walk(stage, topdown=False):
        current = Path(current)
        relative = current.relative_to(stage)
        for name in filenames:
            if relative / name not in files:
                (current / name).unlink()
        for name in names:
            path, key = current / name, relative / name
            if key in directories and not path.is_symlink():
                continue
            if key in files and path.is_symlink():
                continue
            _remove(path)

    for directory in sorted(directories, key=lambda path: len(path.parts)):
        (stage / directory).mkdir(parents=True, exist_ok=True)
    for name, source in files.items():
        _sync_file(source, stage / name)
    return stage


def build(repo, output, typst="typst", prepare_only=False):
    """Build once and always announce readiness to background task runners."""
    repo, output = Path(repo).resolve(), Path(output).resolve()
    print("[build] building", flush=True)
    try:
        stage = prepare(repo, output)
        if not prepare_only:
            output.parent.mkdir(parents=True, exist_ok=True)
            subprocess.run([
                typst, "compile", "--root", str(repo),
                "--font-path", str(repo / "fonts"),
                str(stage / "main.typ"), str(output),
            ], check=True)
        return True
    except Exception as error:
        print(f"[build] failed: {error}", file=sys.stderr, flush=True)
        return False
    finally:
        print("[build] ready", flush=True)


def watch(repo, output, typst="typst", prepare_only=False):
    """Poll sources every half-second and rebuild after saves settle."""
    repo, output = Path(repo).resolve(), Path(output).resolve()
    try:
        previous = source_snapshot(repo, output)
    except OSError:
        previous = {}
    build(repo, output, typst, prepare_only)
    while True:
        time.sleep(0.5)
        try:
            current = source_snapshot(repo, output)
            if current == previous:
                continue
            while True:
                time.sleep(0.2)
                settled = source_snapshot(repo, output)
                if settled == current:
                    break
                current = settled
            previous = current
            build(repo, output, typst, prepare_only)
        except OSError as error:
            print(f"[build] failed: {error}", file=sys.stderr, flush=True)


def main():
    repo = Path(__file__).resolve().parent.parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", nargs="?", type=Path,
                        default=repo / "dist" / "xcpc-codebook.pdf")
    parser.add_argument("--typst", default="typst", help="Typst executable")
    parser.add_argument("--prepare-only", action="store_true")
    parser.add_argument("--watch", action="store_true")
    args = parser.parse_args()
    output = args.output.expanduser().resolve()
    if args.watch:
        try:
            watch(repo, output, args.typst, args.prepare_only)
        except KeyboardInterrupt:
            print("\n[build] stopped", flush=True)
        return 0
    return 0 if build(repo, output, args.typst, args.prepare_only) else 1


if __name__ == "__main__":
    raise SystemExit(main())
