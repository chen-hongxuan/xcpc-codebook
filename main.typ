#import "@preview/theorion:0.6.0": *
#import cosmos.fancy: *   // 选择 fancy 主题样式
#let theorem = theorem.with(numbering: none)
// #set quote(block: true)

#show: show-theorion

#import "template.typ": codebook, code-file, note-box

#let ps(body) = block(
  width: 100%,
  inset: (x: 10pt, y: 8pt),
  fill: rgb("#f3f6fa"),
  stroke: (
    left: 2pt + rgb("#578989"),
  ),
  radius: 2pt,
)[
  *PS: * #body
]

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

useless

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

== 线段树二分

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
  对于 $m in NN^+,a in ZZ$ , 若 $gcd(a,m)=1$ , 则 $ a^phi(m) equiv 1 (mod m) $
]
#theorem[拓展欧拉定理][
  对于 $m,k in NN^+,a in ZZ$ 有 $ a^k equiv cases(
    a^(k mod phi(m)) &#strong[if] gcd(a,m)=1,
    a^k &#strong[if] k<phi(m) and gcd(a,m)!=1,
    a^((k mod phi(m))+phi(m)) &#strong[if] k>=phi(m) and gcd(a,m)!=1
  )#h(1em) (mod m) $
]

=== BSGS & exBSGS

#code-file("code/math/bsgs.cpp")

=== CRT & exCRT

#code-file("code/math/crt.cpp")

=== 线性筛素数&积性函数

#code-file("code/math/linearSieve.cpp")

=== 整除分块



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

=== 无向图

#h(2em) 设多重图 $G(V,E)$ 有 $n$ 个顶点, 那么我们构造如下矩阵 $(D_(i j))_(n times n)$
$ &D_(i j)=cases(
  deg(i) &#strong[if] i=j,
  -|E(i,j)| &#strong[otherwise]
) $
则我们有定理
#theorem[无向图][
  对于任意的 $1<=i<=n$ , 记将 $D$ 去掉第 $i$ 行第 $i$ 列得到的子矩阵为 $D^((i))$ , 则 $G$ 上的以 $i$ 为根的生成树的数量 $tau(G,i)$ 满足 $ tau(G,i) =det D^((i)) $
]
#ps[
  在无向图上区分根是没有意义的, 记 $tau(G)$ 为图 $G$ 的生成树个数, 那么 $tau(G)=tau(G,i)$ .
]

=== 有向图



== Hall定理

#theorem[Hall][
  二分图
]

== Prüfer序列

#h(2em) Prüfer 序列可以将一个带标号的 $n>=3$ 个节点的树用一个值域是 $[1,n]$ 的长度为 $n-2$ 的序列表示, 并且这种对映是双射. 它是这样建立的:\
#h(1em) (1). 选择一个当前的树中的标号最小的叶子节点 $x$.\
#h(1em) (2). 在序列的末尾加入 $x$ 连着唯一的那个点的标号.\
#h(1em) (3). 将 $x$ 删去, 若树还剩下至少 $3$ 个顶点, 则返回 (1).

这样我们就得到了一个长度为 $n-2$ 的序列, 可以验证这个映射是双射. 借助这个双射我们可以得到若干结果

#theorem[Cayley公式][
  完全图(有标号) $K_n$ 的生成树数量为 $ n^(n-2) $
]
#theorem[][
  一个 $n$ 个点的带标号无向图, 它有 $k$ 个连通块, 我们希望添加 $k-1$ 条边使得整个图连通, 假定第 $i$ 个连通块里有 $s_i$ 个顶点, 那么添加边的方案数是$ n^(k-2)product_(i=1)^k s_i $
]

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
