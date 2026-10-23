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

## 单独控制标题是否进入目录

在标题的等号后紧接一个 `&`，即可让该标题只出现在正文中：

```typst
== 格雷码
==& 格雷码
```

第一种写法正常进入目录，第二种写法从目录排除；正文中的标题层级、格式和编号
保持一致，也不会打印 `&`。`=&`、`===&` 等写法同样有效，只影响该标题本身，
不会自动隐藏其子标题。去掉 `&` 即可恢复，目录的层级上限仍由 `template.typ`
中的 `outline(depth: ...)` 控制。

该标记由下面的构建脚本预处理，源文件会保留 `&`。脚本在 `dist/_typst/`
生成可直接编译的副本。下面的自动编译模式会在保存源文件后同步副本和 PDF，
供 Tinymist 持续预览；原始 `main.typ` 中的自定义标记需要经过这一步转换。

## 本地构建

安装 Python 3 和 Typst 0.15.1 或更新版本。仓库中的 Maple Mono 通过 `--font-path fonts`
加载；正文中文字体需要安装 `Noto Serif CJK SC`，或把相应字体文件放入
`fonts/`。然后运行：

```sh
python3 scripts/build.py
```

默认输出 `dist/xcpc-codebook.pdf`，也可指定输出位置：

```sh
python3 scripts/build.py main.pdf
```

## 本地自动编译与预览

在 VS Code 中按 `Ctrl+Shift+B`，即可启动已配置的 `Codebook: watch` 后台任务；
也可以在项目根目录的终端运行：

```sh
python3 scripts/build.py --watch
```

1. 等首次编译完成，打开 `dist/_typst/main.typ`，从这个文件启动 Tinymist 的普通预览。
2. 保持该预览面板打开，回到原始 `main.typ`、`sections/` 或 `code/` 中编辑。
3. 每次保存后，脚本会自动处理 `==&` 标记、同步预览副本并重新编译 PDF，预览随之更新。

使用同一个普通预览面板即可；`Browsing Preview` 会随当前编辑的文件切换入口。
编译出错时监听仍会继续，修正源文件并保存即可重试。终端中可用 `Ctrl+C` 停止；
VS Code 中可通过终止任务停止。也可以直接打开 `dist/xcpc-codebook.pdf` 查看输出。

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
- `scripts/build.py`：处理标题的 `&` 标记并编译 PDF。
- `.github/workflows/build.yml`：自动编译与发布。

发布他人可见的仓库前，请给转载的算法与字体保留来源和许可证；不要直接复制一个
没有明确许可证的仓库内容。
