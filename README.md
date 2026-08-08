# XCPC Typst 代码模板库

这是一个可打印的 A4 双栏 XCPC 队伍参考文档，使用 Typst 生成。仓库将算法源码与
排版分开保存，并通过 GitHub Actions 自动构建 PDF、在打标签时发布 Release。

## 修改自己的模板库

1. 把经过测试的模板放入 `code/`。
2. 在 `main.typ` 中修改学校、队名和队员。
3. 按你想要的顺序添加标题与 `#code-file("code/path/file.cpp")`。
4. 代码尽量控制在 80 列左右，纸面阅读和双栏折行会更稳定。

高亮关键行：

```typst
#code-file("code/data-structure/dsu.cpp", highlights: (13, 18))
```

说明文字、公式和表格直接使用普通 Typst；需要边框提示时可写：

```typst
#note-box[多组数据时记得清空全局数组。]
```

## 本地构建

安装 Typst 0.15.1 或更新版本，并安装 `Noto Serif CJK SC` 中文字体，然后运行：

```sh
typst compile --root . main.typ dist/xcpc-codebook.pdf
```

如果中文字体放在仓库的 `fonts/` 目录，改用：

```sh
typst compile --root . --font-path fonts main.typ dist/xcpc-codebook.pdf
```

## GitHub 自动构建

每次 push 和 pull request 都会运行 `.github/workflows/build.yml`，PDF 可在对应的
Actions 页面作为 Artifact 下载。推送 `v1.0` 这样的标签时，还会自动创建 GitHub
Release 并附上 `xcpc-codebook.pdf`：

```sh
git tag v1.0
git push origin v1.0
```

工作流会在 GitHub runner 中安装 Noto CJK 字体。若希望本地和 GitHub 输出完全一致，
请在两边使用同一字体文件，并通过 `--font-path` 指向它。

## 推荐目录分工

- `main.typ`：个人信息、章节顺序、哪些模板进入 PDF。
- `template.typ`：A4 双栏、页眉、目录、代码块与行号样式。
- `code/`：真正用于比赛的独立算法源码。
- `notes/`：公式、检查表和文字结论。
- `.github/workflows/build.yml`：自动编译与发布。

发布他人可见的仓库前，请给转载的算法与字体保留来源和许可证；不要直接复制一个
没有明确许可证的仓库内容。
