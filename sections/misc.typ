#import "../common.typ": *

= 杂项

== Miller–Rabin 素性测试

#code-info(
  [`MillerRabin::test(n)` 使用固定七组底数判定 `long long` 范围内的非负整数 $n$ 是否为质数，质数返回 $1$，否则返回 $0$。],
  [时间 $O(log n)$，额外空间 $O(1)$；代码已使用 `__int128` 完成安全模乘。],
)
#code-file("code/math/mr.cpp")

== 线性代数类

#code-info(
  [`matrix()` 建立空哨兵；`matrix(n,m,v)` 建立常数矩阵；`matrix(n)` 建立单位阵；`[]/n()/m()` 访问元素与尺寸；`+,-,*`、`fpow` 完成运算；`gauss/det/inv` 求消元结果、行列式与逆矩阵。须将 `_P_` 换成质数，保证元素在 `[0,mo)`，消元矩阵满足 $0<n<=m$，快速幂指数非负。],
  [访问为 $O(1)$，加减为 $O(n m)$；$n times k$ 乘 $k times m$ 为 $O(n k m)$；$n times m$ 消元为 $O(n^2 m)$；方阵快速幂 $O(n^3 log t)$，行列式与求逆 $O(n^3)$；空间 $O(n m)$。],
)
#code-file("code/math/matrix.cpp")

== matrix-tree定理

=== 无向图

#h(2em) 设无向多重图 $G(V,E)$ 有 $n$ 个顶点, 那么我们构造如下矩阵 $(D_(i j))_(n times n)$
$ &D_(i j):=cases(
  deg(i) &#strong[if] i=j,
  -|E(i,j)| &#strong[otherwise]
) $
则我们有定理\ \ 
#theorem[无向图][
  对于任意的 $1<=i<=n$ , 记将 $D$ 去掉第 $i$ 行第 $i$ 列得到的子矩阵为 $D_((i))$ , 则 $G$ 上的以 $i$ 为根的全体生成树 $tau(G,i)$ 构成的集合满足 $ |tau(G,i)| =det D_((i)) $
]
#ps[
  在无向图上区分根是没有意义的, 记 $tau(G)$ 为图 $G$ 的所有生成树构成的集合, 那么 $tau(G)=tau(G,i)$ .
]

=== 有向图

#h(2em) 在多重图 $G(V,E)$ 中我们类似地出两个矩阵 $(D^"in"_(i j))_(n times n),(D^"out"_(i j))_(n times n)$
$
&D^"out"_(i j):=cases(
  deg^"out" (i) &#strong[if] i=j,
  -|E(i->j)| &#strong[otherwise]
),\
&D^"in"_(i j):=cases(
  deg^"in" (i) &#strong[if] i=j,
  -|E(i->j)| &#strong[otherwise]
)
$
则可以类似地导出有向图上的矩阵树定理\ \ 
#theorem[有向图,根向树][
  对于 $1<=i<=n$ , 设将 $D^"out"$ 去掉第 $i$ 行第 $i$ 列得到的子矩阵为 $D^"out"_((i))$ , 则 $G$ 上的以 $i$ 为根的且所有边都指向根节点的全体生成树构成的集合 $tau^"root" (G,i)$ 满足$ |tau^"root" (G,i)|=det D^"out"_((i)) $
]
#theorem[有向图,叶向树][
  对于 $1<=i<=n$ , 设将 $D^"in"$ 去掉第 $i$ 行第 $i$ 列得到的子矩阵为 $D^"in"_((i))$ , 则 $G$ 上的以 $i$ 为根的且所有边都指向叶子的全体生成树构成的集合 $tau^"leaf" (G,i)$ 满足$ |tau^"leaf" (G,i)|=det D^"leaf"_((i)) $
]
=== 带权形式
#h(2em) 边 $e$ 有边权 $w(e)$ , 定义树 $T$ 的权值 $ w(T):=product_(e in T)w(e) $  则对于全体生成树的权值和 $ sum_(T in tau(G,i))w(T) $ 我们只需要把一个权重为 $w(e)$ 的边看成 $w(e)$ 重边即可.

== Hall定理

#h(2em) 对于一个二分图 $G(A,B,E)$ , 不妨设 $|A|<=|B|$ , 则*Hall定理*可以判定完美匹配是否存在.\ \ 

#theorem[Hall][
  $G(A,B,E)$ 存在完美匹配当且仅当对于任意的 $X subset.eq A$ 均有 $ |{y in B: exists x in X "s.t." (x,y)in E }|>=|X| $
]
#corollary[][
  正则二分图均存在完美匹配
]
#ps[
  在一些边集具有特殊性质的二分图里, *Hall定理*有奇效.
]
== Prüfer序列

#h(2em) *Prüfer序列*可以将一个带标号的 $n>=3$ 个节点的树用一个值域是 $[1,n]$ 的长度为 $n-2$ 的序列表示, 并且这种对映是双射. 它是这样建立的:\
#h(1em) (1). 选择一个当前的树中的标号最小的叶子节点 $x$.\
#h(1em) (2). 在序列的末尾加入 $x$ 连着唯一的那个点的标号.\
#h(1em) (3). 将 $x$ 删去, 若树还剩下至少 $3$ 个顶点, 则返回 (1).

这样我们就得到了一个长度为 $n-2$ 的序列, 可以验证这个映射是双射. 借助这个双射我们可以得到若干结果.\ \ 

#theorem[Cayley公式][
  完全图(有标号) $K_n$ 的生成树数量为 $ n^(n-2) $
]
#corollary[][
  一个 $n$ 个点的带标号无向图, 它有 $k$ 个连通块, 我们希望添加 $k-1$ 条边使得整个图连通, 假定第 $i$ 个连通块里有 $s_i$ 个顶点, 那么添加边的方案数是$ n^(k-2)product_(i=1)^k s_i $
]
== 虚树

#code-info(
  [`VirtualTree(DFN,DEP,lca,root)` 保存同一棵有根树的信息；`work(Nd,tree,lnk)` 建立虚树并返回点数，其中 `tree[u]` 记录虚树儿子，`lnk[u]` 映射回原树，虚树根编号为 $1$。要求关键点互异且均在 `root` 子树内；`Nd` 按值传入，原顺序不变。],
  [设关键点数为 $k$、单次 LCA 为 $L$，初始化时间和空间 $O(n)$；单次建树 $O(k log k+k L)$，输出空间 $O(k)$。],
)
#code-file("code/graph/virtualtree.cpp")

== 拉格朗日插值

#code-info(
  [`insert(x,y)` 加入采样点，返回 $1/0/-1$ 分别表示新增、完全重复、同横坐标取值冲突；`find(u)` 求插值多项式在 $u$ 处的值并自动归一化 $u$；`fast_construct(l,y)` 建立横坐标为 $l,l+1,dots$ 的采样点。须将 `_P_` 换成质数，保证存入的坐标在 `[0,mo)` 且横坐标模意义下互异。],
  [已有 $k$ 个点、模数为 $p$ 时，插入 $O(k)$、单点求值 $O(k log p)$、连续点构造 $O(k)$；存储空间 $O(k)$。],
)
#code-file("code/math/lagrange.cpp")

== LGV引理

== 高精度

寫你撚個臭閪嘅高精度，去寫 python 喇黐線。

== 高位前缀和/差分

#code-info(
  [`sum_of_subset(n,f,sum)` 求每个集合的所有子集权值和；`diff_of_subset(n,f,diff)` 执行其 Möbius 逆变换。要求 `f` 按二进制集合编号并至少含 $2^n$ 项；当前 `1<<n` 的写法要求 $0<=n<31$。],
  [时间 $O(n 2^n)$，输出空间 $O(2^n)$，除此之外额外空间 $O(1)$。],
)
#code-file("code/math/sum&diff.cpp")

== FWT & FMT

== 三元环计数

#definition[三元环][
  在简单无向图 $G=(V,E)$ 中, 若三个不同的点 $u,v,w$ 两两相连, 则无序三元组 $(u,v,w)$ 构成一个三元环. 三元环计数即求图中不同三元环的数量.
]\
#h(2em) 先给每条边定向: 从度数较小的点指向度数较大的点; 度数相同时, 从编号较小的点指向编号较大的点. 点的度数与编号按字典序严格增大, 因此定向后的图是一张 DAG. 随后执行:

1. 枚举每条有向边 $u->v$.
2. 枚举 $v$ 的每条出边 $v->w$.
3. 若原图中存在边 $(u,w)$, 就找到一个三元环并将答案加 $1$.\ \ 

#theorem[正确性与复杂度][
  一个三元环的三个点按上述顺序排列后, 边的方向必为 $u->v,u->w,v->w$, 因此它恰好会被统计一次. 对任意点 $v$, 若 $d_v<=sqrt(m)$, 则其出度显然不超过 $sqrt(m)$; 否则它只能指向度数同样大于 $sqrt(m)$ 的点, 而这样的点至多有 $O(sqrt(m))$ 个. 所以每条边之后至多继续枚举 $O(sqrt(m))$ 条边, 总时间复杂度为 $O(m sqrt(m))$.
]


== 四边形不等式优化
