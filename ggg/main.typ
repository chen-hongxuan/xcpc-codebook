#import "@preview/theorion:0.6.0": *
#import cosmos.fancy: *   // 选择 fancy 主题样式
#let theorem = theorem.with(numbering: none)

#show: show-theorion

#import "template.typ": codebook, code-file, note-box

#show: codebook.with(
  title: "chx@xjtu's XCPC codebook",
  short-title: "XCPC Codebook",
  school: "Xi'an Jiaotong University",
  team: "Emperor of Kirin",
  members: ("chx*", "wjr", "jyc"),
)

= 基础 / Basic

== 比赛模板

#code-file("code/basic/template.cpp")

#note-box[
  *提交前检查：* 整数范围、数组边界、多测清空、递归深度，以及输出格式。
]

== 对拍模板

= 字符串 / String

== 算法

=== 哈希类(三哈希)

#code-file("code/string/hash.cpp")

=== AC自动机

#code-file("code/string/acam.cpp")

=== KMP & exKMP

#code-file("code/string/kmp.cpp")

=== 后缀自动机

#code-file("code/string/sam.cpp")

=== 回文自动机

STO$PP$ LE$AA$RNING USELESS ALGORITH$MM$!

=== 后缀排序

#code-file("code/string/sa.cpp")

== 结论

= 图论 / Graph

== 最短路

=== Dijkstra

接口规则

```
dijkstra::work(n,s,edge,dis)
n -> 节点个数
s -> 起点集合
edge -> 边集, 边的存储格式为{v(指向),w(边权)}
dis -> 导出的最短路数组
```


Time Complexity: $O((N+M)log M)$

#code-file("code/graph/dijkstra.cpp")

=== SPFA

#code-file("code/graph/spfa.cpp")

==== 应用: 差分约束

=== Johnson全源最短路

== Tarjan

=== 强连通分量

#code-file("code/graph/tarjan1.cpp")

==== 应用: 2-SAT建图

一个 2-SAT 问题是, 有 $n$ 个

=== 边双

#code-file("code/graph/tarjan2.cpp")

=== 点双

#code-file("code/graph/tarjan3.cpp");

== 生成树

=== Prim

=== Kruskal

#code-file("code/graph/kruskal.cpp")

==== 应用: Kruskal 重构树

=== Boruvka

=== 可撤销并查集

#code-file("code/graph/undodsu.cpp")

= 网络流 / Flow

== 算法

=== 网络最大流

#code-file("code/graph/dinic.cpp")

=== 最小费用最大流

#code-file("code/graph/mcmf.cpp")

==== 应用: 最小费用可行流

=== 上下界最小费用可行流

== 常见建模

== 模拟费用流(反悔贪心)


= 数据结构 / Data Structure

== 树状数组

#code-file("code/data-structure/bittree.cpp")

== 主席树

#code-file("code/data-structure/jtree.cpp")

== 可裂&可并线段树

#code-file("code/data-structure/sgmTree.cpp")

== 势能线段树

== FHQ_Treap

#code-file("code/data-structure/fhqtreap.cpp")

= 数学 / Math

== 博弈论

== 组合数学-

=== 容斥原理

==== 子集反演
==== 二项式反演
==== 斯特林反演
==== min-max反演

=== Lucas 定理

=== 斯特林数

=== 卡特兰数

=== 生成函数

== 数论

=== $mu$-反演

=== Extended GCD

#code-file("code/math/exgcd.cpp")

=== 欧拉取模定理

#theorem[欧拉定理][
]
#theorem[拓展欧拉定理][

]

=== BSGS & exBSGS

#code-file("code/math/bsgs.cpp")

=== CRT & exCRT

#code-file("code/math/crt.cpp")

=== 线性筛素数&积性函数

#code-file("code/math/linearSieve.cpp")

=== 数论分块

=== 杜教筛

#code-file("code/math/Du'sSieve.cpp")

=== Min_25筛



=== 类欧几里得方法

== 多项式
=== 复数FFT

#code-file("code/math/fft.cpp")

=== 取模全家桶
#code-file("code/math/poly(mod).cpp")

= 杂项

== 线性代数类

#code-file("code/math/matrix.cpp")

== matrix-tree定理

== Prufer序列

== 拉格朗日插值

#code-file("code/math/lagrange.cpp")

== LGV引理

== 高精度

寫你撚個臭閪嘅高精度，去寫 python 喇黐線。

== 高位前缀和/差分

#code-file("code/math/sum&diff.cpp")

== FWT & FMT

去问王君睿.

== 四边形不等式优化

= 检查表 / Checklist

#include "notes/checklist.typ"
