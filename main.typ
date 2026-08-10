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

=== 并查集

=== matrix-tree定理

=== Prim

=== Kruskal

==== 应用: Kruskal 重构树

=== Boruvka

= 网络流 / Flow

== 算法

=== 网络最大流

#code-file("code/graph/dinic.cpp")

=== 最小费用最大流

=== 最大费用可行流

=== 上下界最小费用可行流

== 常见建模

== 模拟费用流(反悔贪心)



= 计算几何 / Geometry

= 数据结构 / Data Structure

== 树状数组

#code-file("code/data-structure/bittree.cpp")

== 主席树

#code-file("code/data-structure/jtree.cpp")

== 可裂&可并线段树

= 数学 / Math

== 线性代数

=== 矩阵类

=== 高斯消元&行列式

== 组合数学

=== 容斥原理

==== 子集反演
==== 二项式反演
==== 斯特林反演
==== min-max反演

=== 斯特林数

=== 卡特兰数

=== 生成函数

== 数论

=== Extended GCD

#code-file("code/math/exgcd.cpp")



=== BSGS & exBSGS

#code-file("code/math/bsgs.cpp")

=== CRT & exCRT


=== Lucas & exLucas


=== 线性筛素数&积性函数

#code-file("code/math/linearSieve.cpp")

=== 杜教筛

=== min25筛

== 多项式
=== 复数FFT

#code-file("code/math/fft.cpp")

=== 取模全家桶
#code-file("code/math/poly(mod).cpp")

= 杂项

== 拉格朗日插值

== LGV引理

== 高精度

寫你撚個臭閪嘅高精度，去寫 python 喇黐線。

== 高位前缀和/差分

== FWT & FMT

= 检查表 / Checklist

#include "notes/checklist.typ"
