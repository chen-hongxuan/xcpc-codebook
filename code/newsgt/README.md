# 线段树模板

本目录完整复制自 `code/sgt/`，将普通树、动态树与主席树合并到同一个 `SegmentTree` 主体。
正式代码本已通过 `sections/data-structure.typ` 引用本目录，原 `code/sgt/` 保留供对照。

## 看哪些文件

- `struct.cpp`：统一主体，保留原节点布局和辅助函数；节点池共享，每个对象只有一个根。
- `normal/`：普通树的建树、单点加、区间修改框架、查询及二分片段。
- `ins/`：动态插入、对象合并与分裂片段，查询共用 `normal/query.cpp`。
- `jtree/`：主席树片段，每个对象代表一个版本，可用外部 `vector<SegmentTree>` 保存。
- `example.cpp`、`normal/example.cpp`、`jtree/example.cpp`：三种组合的使用示例。
- `jtree/range-kth.cpp`：可直接放入 `solve()` 的静态区间第 k 小调用样例，包含离散化和原值还原。
- `preview.typ`：独立预览完整章节，沿用现有 A4 双栏版式。
- `sgt.typ`：正式代码本使用的线段树章节，所有代码引用已指向本目录。
- `origin/`：复制保留的历史代码，不参与当前主体的组装和预览。

## 组合与使用

依赖基础模板的头文件、`using namespace std`、`#define int long long`。
类内通过 `using sgt=SegmentTree` 缩短参数、返回类型及局部声明；构造函数名仍为 `SegmentTree`。
将所需成员片段放入 `struct.cpp` 的预留位置：

- 普通树：`normal/build.cpp`、`normal/add.cpp`、`normal/query.cpp`，可调用
  `a.build()`、`a.modify(x,d)`、`a.query(l,r)`；其余模块按需添加。
- 动态树：`ins/insert.cpp`、`ins/merge.cpp`、`ins/split.cpp` 和同一份
  `normal/query.cpp`，可调用 `a.insert(x,d)`、`a.query(l,r)`、`a.merge(b)`、`auto b=a.split(x)`。
- 主席树：四个 `jtree/` 片段，单版本查询复用 `normal/query.cpp`。
  `v.emplace_back(l,r)` 创建空版本，无须提前建树；
  `v.push_back(v.back().jmodify(x,d))` 保存新版本，旧版本不变。
  `v[r].jquery(v[l-1],ql,qr)` 查询版本差的区间和，
  `v[r].kth(v[l-1],k)` 查询版本差中的第 k 小，`v[t].kth(k)` 查询单版本。

普通树与动态树的成员片段可同时加入同一个主体，查询只加入一次。
原来的带根编号递归接口保留，因此仍可运行旧的长链线段树示例。

合并要求值域相同，会清空 `b`；分裂后两棵树保留原值域。
对象禁止普通复制，使用 `move` 转移根，源对象随后为空。
节点池由全部对象共享，节点暂不回收；下一组数据创建树之前调用
`SegmentTree::clear()`，不要在仍需使用其他树或历史版本时清空池。

主席树版本之间共享节点；派生历史版本后，只通过 `jmodify` 修改，
不要对这些版本执行普通修改、动态插入、重建或破坏性的 `merge/split`。
`jquery/kth` 为只读查询，不下传标记、不创建节点；第 k 小要求逐点频数差非负。
原来的根编号接口仍可使用，`jmodify(0,x,d)` 按当前对象的值域创建路径。

当前实现维护单点加与区间和，不使用懒标记。`pushdown` 保留扩展位置；
扩展区间修改时，需要自行补齐标记及动态开点规则。

## 验证与预览

在项目根目录运行：

```sh
python3 code/newsgt/test.py
mkdir -p output/pdf
typst compile --root . --font-path fonts code/newsgt/preview.typ output/pdf/newsgt-preview.pdf
```

测试会临时组合实际片段，以 GNU++17 和 AddressSanitizer/UndefinedBehaviorSanitizer
验证普通树、主席树的稀疏空版本与历史版本保持、原长链示例兼容性，以及动态树的空树、合并、分裂、移动、
容器扩容、节点归属与随机操作，临时文件运行后清理。
