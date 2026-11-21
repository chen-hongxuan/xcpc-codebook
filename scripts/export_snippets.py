#!/usr/bin/env python3
"""Export the codebook to Horyce.custom-snippet-manager, optionally install it."""

import argparse
import bisect
from collections import Counter, defaultdict
from datetime import datetime, timezone
import json
from pathlib import Path
import re
import shutil
import subprocess
import uuid


ROOT = Path(__file__).resolve().parents[1]
EXTENSION = "horyce.custom-snippet-manager"
NAMESPACE = uuid.uuid5(uuid.NAMESPACE_URL, "xcpc-codebook/custom-snippet-manager")
LANGUAGES = {".cpp": "cpp", ".sh": "shellscript", ".py": "python"}
CATEGORIES = {
    "basic": "基础模板与脚本", "graph": "图论", "string": "字符串",
    "geometry": "计算几何", "math": "数学", "matrix": "矩阵",
    "mo": "莫队", "newsgt": "线段树（当前）", "sgt": "线段树（旧）",
    "data-structure": "其他数据结构", "polynomial": "多项式",
    "longchain": "长链剖分", "stl": "STL与pb_ds", "tools": "辅助验证脚本",
}
RETIRED_CATEGORIES = {"sgt"}
# Included Typst files may start at "公共结构" without their enclosing chapter.
# Keep the owning data structure visible at the start of the snippet name.
TITLE_OVERRIDES = {
    "code/newsgt/struct.cpp": "线段树（当前） · 公共结构",
    "code/newsgt/jtree/bas.cpp": "主席树（当前） · 公共结构（节点克隆）",
    "code/newsgt/lichao.cpp": "李超线段树 · 公共结构（含直线结构）",
    "code/newsgt/lichao.cpp#tree": "李超线段树 · 公共结构（分段）",
    "code/newsgt/lichao.cpp#line": "李超线段树 · 直线结构（分段）",
    "code/geometry/convex.cpp": "凸包 · 公共结构",
    "code/geometry/circle.cpp": "圆 · 公共结构",
    "code/geometry/struct.cpp": "二维几何 · 公共结构（向量与直线）",
    "code/geometry/polygon.cpp": "多边形 · 完整结构",
    "code/matrix/struct.cpp": "矩阵 · 公共结构",
    "code/math/matrix.cpp": "矩阵（旧） · 完整模板",
    "code/polynomial/struct.cpp": "多项式 · 公共结构",
    "code/longchain/struct.cpp": "长链剖分 · 公共结构",
    "code/longchain/init.cpp": "长链剖分 · 初始化与预处理",
}
STYLE = (
    "{BasedOnStyle: LLVM, IndentWidth: 4, ContinuationIndentWidth: 4, "
    "TabWidth: 4, UseTab: Never, ColumnLimit: 0, NamespaceIndentation: All, "
    "AlignAfterOpenBracket: DontAlign, AlignOperands: DontAlign, "
    "AccessModifierOffset: -4, IndentCaseLabels: true, SortIncludes: Never, "
    "FixNamespaceComments: false, BreakStringLiterals: false, ReflowComments: false, "
    "AllowShortFunctionsOnASingleLine: All, "
    "AllowShortIfStatementsOnASingleLine: AllIfsAndElse, "
    "AllowShortLoopsOnASingleLine: true}"
)
MARKER = re.compile(r"^\s*// codebook: ([\w-]+)\s*$", re.MULTILINE)
FENCE = re.compile(r"^\s*```(cpp|c\+\+|bash|sh|python)\s*\n(.*?)^\s*```\s*$",
                   re.MULTILINE | re.DOTALL)
HEADING = re.compile(r"^\s*(=+)&?\s+(.+?)\s*$", re.MULTILINE)
REFERENCE = re.compile(r'#code-file\("([^"]+)"(?:,\s*part:\s*"([^"]+)")?')


def write_json(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=4) + "\n")


def find_formatter():
    found = shutil.which("clang-format")
    if found:
        return found
    candidates = sorted((Path.home() / ".vscode/extensions").glob(
        "ms-vscode.cpptools-*/LLVM/bin/clang-format"))
    if not candidates:
        raise RuntimeError("需要 clang-format（也可使用 VS Code C/C++ 扩展自带的版本）。")
    return str(candidates[-1])


def indent4(source, language, formatter):
    """Use clang-format's indentation, retaining original line contents/layout."""
    lines = source.splitlines()
    if language == "python":
        # This auxiliary script already uses four spaces. Keep multiline literals.
        return source.rstrip("\n")
    if language == "shellscript":
        return "\n".join(
            " " * len(re.match(r"[ \t]*", line)[0].expandtabs(2)) * 2
            + line.lstrip(" \t") if line.strip() else ""
            for line in lines
        ).rstrip("\n")

    formatted = subprocess.run(
        [formatter, "--style=" + STYLE, "--assume-filename=snippet.cpp"],
        input=source, text=True, capture_output=True, check=True,
    ).stdout
    if re.sub(r"\s", "", source) != re.sub(r"\s", "", formatted):
        raise ValueError("clang-format 修改了代码字符，已停止导出。")
    indents = {}
    offset = 0
    for line in formatted.splitlines():
        if line.strip():
            width = len(line) - len(line.lstrip(" "))
            indents[offset] = (width + 3) // 4 * 4
        offset += len(re.sub(r"\s", "", line))
    # A formatter may join short statements. Fall back to the source's indent unit.
    widths = [len(line) - len(line.lstrip(" ")) for line in lines if line.startswith(" ")]
    unit = 4 if widths and min(widths) >= 4 else 2
    result = []
    offset = 0
    for line in lines:
        if line.strip():
            leading = len(re.match(r"[ \t]*", line)[0].expandtabs(unit))
            width = indents.get(offset, (leading + unit - 1) // unit * 4)
            result.append(" " * width + line.lstrip(" \t"))
        else:
            result.append("")
        offset += len(re.sub(r"\s", "", line))
    return "\n".join(result).rstrip("\n")


def snippet_body(code):
    # The extension inserts a VS Code SnippetString, rather than plain text.
    return re.sub(r"[\\$}]", lambda match: "\\" + match[0], code)


def category(path):
    if path.suffix == ".py":
        return "tools"
    parts = path.parts
    if "origin" in parts:
        return "sgt"
    if parts[0] == "sections":
        return {"geometry": "geometry", "basic": "basic"}[path.stem]
    return parts[1]


def collect_sources():
    """Include source files, printed regions, and inline runnable code examples."""
    labels = {}
    examples = []
    documents = sorted((ROOT / "sections").glob("*.typ"))
    documents += sorted((ROOT / "code").rglob("*.typ"))
    for document in documents:
        text = document.read_text()
        headings = []
        positions = []
        titles = []
        for heading in HEADING.finditer(text):
            level, title = len(heading[1]), heading[2]
            headings = [(depth, name) for depth, name in headings if depth < level]
            headings.append((level, title))
            positions.append(heading.start())
            titles.append(" / ".join(name for _, name in headings[-2:]))

        def title_at(position):
            index = bisect.bisect_right(positions, position) - 1
            return titles[index] if index >= 0 else document.stem

        for reference in REFERENCE.finditer(text):
            labels.setdefault((reference[1], reference[2]), title_at(reference.start()))
        for index, fence in enumerate(FENCE.finditer(text), 1):
            path = document.relative_to(ROOT)
            language = {"cpp": "cpp", "c++": "cpp", "bash": "shellscript",
                        "sh": "shellscript", "python": "python"}[fence[1]]
            examples.append((path, f"example-{index}", language, fence[2],
                             title_at(fence.start()) + "（调用/配置示例）"))

    sources = []
    for path in sorted((ROOT / "code").rglob("*")):
        if path.suffix not in LANGUAGES:
            continue
        relative = path.relative_to(ROOT)
        text = path.read_text()
        title = labels.get((relative.as_posix(), None), relative.stem)
        sources.append((relative, None, LANGUAGES[path.suffix], text, title))
        markers = list(MARKER.finditer(text))
        for index, marker in enumerate(markers):
            end = markers[index + 1].start() if index + 1 < len(markers) else len(text)
            title = labels.get((relative.as_posix(), marker[1]), marker[1])
            sources.append((relative, marker[1], LANGUAGES[path.suffix],
                            text[marker.end():end].strip("\n"), title + "（分段）"))
    return sources + examples


def export(output, formatter):
    timestamp = datetime.now(timezone.utc).isoformat(timespec="seconds")
    groups = defaultdict(list)
    manifest = []
    for path, part, language, source, title in collect_sources():
        group = category(path)
        if group in RETIRED_CATEGORIES:
            continue
        key = path.as_posix() + ("#" + part if part else "")
        title = TITLE_OVERRIDES.get(key, title)
        code = indent4(source, language, formatter)
        prefix = "xcpc-" + re.sub(r"[^a-z0-9]+", "-", str(path.with_suffix("")).lower()).strip("-")
        if part:
            prefix += "-" + part
        snippet = {
            "id": str(uuid.uuid5(NAMESPACE, key)),
            "name": f"{title} · {key}", "prefix": prefix,
            "body": snippet_body(code), "description": f"XCPC 模板库：{key}",
            "language": language, "usageCount": 0, "createdAt": timestamp,
            "xcpcManaged": True, "xcpcSource": key,
        }
        groups[group].append(snippet)
        manifest.append({"source": key, "category": CATEGORIES[group],
                         "language": language, "id": snippet["id"]})
    prefixes = [snippet["prefix"] for snippets in groups.values() for snippet in snippets]
    if len(prefixes) != len(set(prefixes)):
        raise ValueError("存在重复的片段前缀。")
    folders = [{"id": "default", "name": "", "createdAt": timestamp, "order": 0}]
    write_json(output / "storage/folders/default.json", [])
    for key, name in CATEGORIES.items():
        if key not in groups:
            continue
        folder = {"id": "xcpc-" + key, "name": "XCPC · " + name,
                  "createdAt": timestamp, "order": len(folders)}
        folders.append(folder)
        write_json(output / f"storage/folders/{folder['id']}.json", groups[key])
        write_json(output / f"import/{key}.json", {
            "version": "2.0", "exportedAt": timestamp, "appVersion": "1.6.0",
            "folder": {"name": folder["name"]}, "snippets": groups[key],
        })
    write_json(output / "storage/folders.json", folders)
    write_json(output / "manifest.json", manifest)
    for key in RETIRED_CATEGORIES:
        (output / f"import/{key}.json").unlink(missing_ok=True)
        (output / f"storage/folders/xcpc-{key}.json").unlink(missing_ok=True)
    print(f"已导出 {len(manifest)} 个片段、{len(folders) - 1} 个分类：{output}")
    print("语言：" + str(dict(Counter(item["language"] for item in manifest))))


def install(output, user_dir):
    target = user_dir / "globalStorage" / EXTENSION
    settings_path = user_dir / "settings.json"
    settings = json.loads(settings_path.read_text()) if settings_path.exists() else {}
    settings["editor.snippetSuggestions"] = "none"
    for language in ("cpp", "shellscript", "python"):
        settings.setdefault(f"[{language}]", {}).update({
            "editor.tabSize": 4, "editor.insertSpaces": True,
            "editor.detectIndentation": False,
        })
    desired = json.loads((output / "storage/folders.json").read_text())
    old_meta = target / "folders.json"
    folders = json.loads(old_meta.read_text()) if old_meta.exists() else [desired[0]]
    all_ids = {folder["id"] for folder in folders}
    payloads = {}
    for folder in folders:
        path = target / "folders" / (folder["id"] + ".json")
        legacy = target / "snippets.json"
        if not old_meta.exists() and folder["id"] == "default" and legacy.exists():
            path = legacy
        payloads[folder["id"]] = json.loads(path.read_text()) if path.exists() else []
    previous = {item["id"]: item for items in payloads.values() for item in items}
    for key in payloads:
        payloads[key] = [item for item in payloads[key] if not item.get("xcpcManaged")]
    for folder in desired[1:]:
        folder_id = folder["id"]
        if folder_id not in all_ids:
            folder["order"] = max(item.get("order", 0) for item in folders) + 1
            folders.append(folder)
        snippets = json.loads((output / f"storage/folders/{folder_id}.json").read_text())
        for snippet in snippets:
            old = previous.get(snippet["id"], {})
            for field in ("usageCount", "createdAt"):
                if field in old:
                    snippet[field] = old[field]
        payloads.setdefault(folder_id, []).extend(snippets)

    retired_ids = {"xcpc-" + key for key in RETIRED_CATEGORIES}
    # Remove retired folders after clearing managed entries; retain personal snippets.
    removed_ids = {key for key in retired_ids if not payloads.get(key)}
    folders = [folder for folder in folders if folder["id"] not in removed_ids]
    for key in removed_ids:
        payloads.pop(key, None)

    # Back up before changing either VS Code data file. Re-imports retain user data.
    stamp = datetime.now().strftime("%Y%m%d-%H%M%S-%f")
    backup = user_dir / "globalStorage/xcpc-snippet-backups" / stamp
    backup.mkdir(parents=True)
    if target.exists():
        shutil.copytree(target, backup / EXTENSION)
    if settings_path.exists():
        shutil.copy2(settings_path, backup / "settings.json")
    for folder_id, snippets in payloads.items():
        write_json(target / f"folders/{folder_id}.json", snippets)
    write_json(target / "folders.json", folders)
    for folder_id in removed_ids:
        (target / f"folders/{folder_id}.json").unlink(missing_ok=True)
    write_json(settings_path, settings)
    print(f"已安装到：{target}")
    print(f"原配置备份：{backup}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "dist/snippets")
    parser.add_argument("--clang-format", default=None)
    parser.add_argument("--install", action="store_true", help="同时更新本机插件及四空格设置")
    parser.add_argument("--user-dir", type=Path, default=Path.home() / ".config/Code/User")
    args = parser.parse_args()
    export(args.output, args.clang_format or find_formatter())
    if args.install:
        install(args.output, args.user_dir)


if __name__ == "__main__":
    main()
