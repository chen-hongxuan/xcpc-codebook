#import "@preview/theorion:0.6.0": *
#import cosmos.fancy: *   // 选择 fancy 主题样式
#let theorem = theorem.with(numbering: none)
#let corollary = corollary.with(numbering: none)
#let property = property.with(numbering: none)
#let definition = definition.with(numbering: none)
#let example = example.with(numbering: none)
#let problem = problem.with(numbering: none)
// #set quote(block: true)

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#let stl1(n, k) = math.vec(
  n, k,
  delim: "[",
  gap: 0.1em,
)

#let stl2(n, k) = math.vec(
  n, k,
  delim: "{",
  gap: 0.1em,
)

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

#let code-info(api, complexity) = block(
  width: 100%,
  inset: (left: 2pt),
  above: 0pt,
  below: 1pt,
  stroke: (left: 0.5pt + luma(150)),
)[
  #set text(size: 6.5pt)
  *接口:* #api \
  *复杂度:* #complexity
]

#show: codebook.with(
  title: "chx@xjtu's XCPC codebook",
  short-title: "XCPC Codebook",
  school: "Xi'an Jiaotong University",
  team: "Emperor of Kirin",
  author: "chenhongxuan",
)

= 基础 / Basic

== 比赛模板

#code-info(
  [`read()` 读整数；`chmin/chmax` 条件更新；`red` 单次归约；`qpow` 求模幂；`solve()` 为单组入口。],
  [`read` 为 $Theta(k)$（$k$ 为读取字符数），`qpow` 为 $O(log(t+1))$，其余辅助函数 $O(1)$；额外空间均为 $O(1)$。],
)
#code-file("code/basic/template.cpp")

#note-box[
  *提交前检查：* 整数范围、数组边界、多测清空、递归深度，以及输出格式。
]

== 对拍模板

#code-info(
  [`main()` 编译生成器、标准程序与待测程序，循环生成数据并用 `diff` 比较输出，直到发现差异。],
  [时间正比于编译及已执行轮次的总耗时，若始终无差异则不终止；自身额外空间 $O(1)$，磁盘空间为一轮输入、输出与可执行文件总大小。],
)
#code-file("code/basic/chk_template.cpp");

= 字符串 / String

== 算法

=== 哈希类(三哈希)

#code-info(
  [`HASH(x)`/`HASH(x,y,z)` 构造三元哈希；`[]` 访问分量；`+=,-=,*=` 及对应二元运算逐模计算；比较运算比较三元组。],
  [模数个数固定为 $3$，所有接口的时间与额外空间均为 $O(1)$。],
)
#code-file("code/string/hash.cpp")

=== AC自动机

#code-info(
  [`init()` 清空；`insert(str)` 插入小写模式串并返回终点；`construct()` 构造 fail 指针并补全转移。],
  [设模式总长为 $L$、状态数为 $P$：插入总计 $O(L)$，构造 $O(P)$，空间 $O(P)$；当前 `cnt` 未给根节点预留位置，`insert` 会越界。],
)
#code-file("code/string/acam.cpp")

=== KMP & exKMP

#code-info(
  [`KMP(x,pi)` 求失配数组（最长真 border 的末下标）；`exKMP(x,z)` 求各后缀与原串的 LCP，约定 `pi[0]=-1,z[0]=0`。],
  [字符串长度为 $n$ 时，两者均为 $O(n)$ 时间、$O(n)$ 输出空间，除此之外额外空间 $O(1)$。],
)
#code-file("code/string/kmp.cpp")

=== 后缀自动机

#code-info(
  [`sam_init()` 重置；`extend(c)` 追加小写字符；`construct(str)` 重建 SAM 并返回整串对应的 `last` 状态。],
  [长度为 $n$ 的整串构造总时间、状态数与空间均为 $O(n)$；单次 `extend` 最坏 $O(n)$、序列上均摊 $O(1)$。],
)
#code-file("code/string/sam.cpp")

=== 回文自动机

STO$PP$ LE$AA$RNING USELESS ALGORITH$MM$!

=== 后缀排序

#code-info(
  [`work(s,sa,opt)` 将第 $i$ 小后缀的起点写入 `sa[i]`；`opt=0` 仅返回最终排名，`opt=1` 返回各倍增长度的排名数组。],
  [时间 $O(n log^2 n)$；`opt=0` 空间 $O(n)$，`opt=1` 空间 $O(n log n)$。],
)
#code-file("code/string/sa.cpp")

== 结论

= 图论 / Graph

== 最短路

=== Dijkstra

#code-info(
  [`work(n,s,edge,dis)` 在非负权图上求多源最短路，源点集为 `s`，结果写入 `dis`。],
  [时间 $O((n+m)log n)$，空间 $O(n+m)$。],
)
#code-file("code/graph/dijkstra.cpp")

=== SPFA

#code-info(
  [`work(n,s,edge,dis)` 求多源最短路并写入 `dis`；返回 `1` 表示存在从源集可达的负环，否则返回 `0`。],
  [最坏时间 $O(n m)$，额外空间 $O(n)$。],
)
#code-file("code/graph/spfa.cpp")

==== 应用: 差分约束

#definition[差分约束][
  差分约束是由若干形如 $x_i-x_j<=c$ 的一次不等式组成的约束系统. 我们需要判断它是否有解, 并求出一组满足所有限制的变量值.
]\ 
#h(2em) 将限制统一写成 $x_v<=x_u+w$, 它与最短路的松弛条件 $d_v<=d_u+w$ 相同, 因此从 $u$ 向 $v$ 连一条权为 $w$ 的有向边. 常见限制的连边方式如下:

1. $x_a-x_b<=c$: 从 $b$ 向 $a$ 连权为 $c$ 的边.
2. $x_a-x_b>=c$: 化为 $x_b-x_a<=-c$, 从 $a$ 向 $b$ 连权为 $-c$ 的边.
3. $x_a-x_b=c$: 同时连 $b$ 到 $a$ 的 $c$ 边和 $a$ 到 $b$ 的 $-c$ 边. 特别地, $x_a=x_b$ 时两条边的权均为 $0$.

#h(2em) 新建超级源点 $s$, 从 $s$ 向每个变量点连权为 $0$ 的边, 再运行 Bellman--Ford 或 SPFA. 超级源点使所有点均可达, 从而能够检查整个图中的矛盾.
\ \ 
#theorem[求解结果][
  若图中存在负环, 则沿环累加会得到矛盾, 原约束系统无解; 否则令 $x_i=d_i$, 其中 $d_i$ 是 $s$ 到 $i$ 的最短路, 就得到一组可行解.
]
#ps[
  解通常不唯一: 若 $(x_1,...,x_n)$ 是一组解, 则所有变量同时加上同一常数后仍然是解. 对于整数变量, 严格限制 $x_a-x_b<c$ 与 $x_a-x_b>c$ 可分别改写为 $<=c-1$ 与 $>=c+1$.
]


=== Johnson全源最短路

useless

== Tarjan

=== 强连通分量

#code-info(
  [`work(n,edge,color)` 对有向图进行 SCC 染色并返回分量数；编号按 Tarjan 出栈顺序生成。],
  [时间 $O(n+m)$，额外空间 $O(n)$，递归栈最深 $O(n)$。],
)
#code-file("code/graph/tarjan1.cpp")

==== 应用: 2-SAT建图

#definition[2-SAT][
  有 $n$ 个布尔变量, 整个命题由若干个形如 $L_1 or L_2$ 的子句取合取构成, 其中每个文字 $L$ 是某个变量或其否定. 2-SAT 要求判断是否存在一种赋值使所有子句成立, 并在有解时构造一组方案.
]\ 
#h(2em) 对每个变量建立两个点: $F_i=i$ 表示 $x_i=0$, $T_i=i+n$ 表示 $x_i=1$, 二者互为否定点. 有向边 $A->B$ 表示文字 $A$ 成立会迫使 $B$ 成立. 子句 $L_1 or L_2$ 等价于两条蕴含边 $¬L_1->L_2$ 和 $¬L_2->L_1$.

#table(
  columns: (1fr, 1.5fr),
  stroke: 0.35pt + luma(150),
  inset: 2pt,
  align: center,
  [*子句*], [*蕴含边*],
  [$x_a or x_b$], [$F_a->T_b,F_b->T_a$],
  [$x_a or ¬x_b$], [$F_a->F_b,T_b->T_a$],
  [$¬x_a or x_b$], [$T_a->T_b,F_b->F_a$],
  [$¬x_a or ¬x_b$], [$T_a->F_b,T_b->F_a$],
)

#theorem[判定与构造][
  对蕴含图求强连通分量. 若存在 $i$ 使 $T_i,F_i$ 位于同一个 SCC, 则 $x_i$ 与其否定互相蕴含, 原问题无解; 否则一定有解. 在缩点 DAG 中, 对每个变量令拓扑序较靠后的文字成立, 即可得到一组合法赋值. 时间和空间复杂度均为 $O(n+m)$.
]
#ps[
  至少一个为真使用 $x_a or x_b$, 至多一个为真使用 $¬x_a or ¬x_b$; $x_a=x_b$ 同时加入 $x_a or ¬x_b$ 与 $¬x_a or x_b$, $x_a!=x_b$ 同时加入 $x_a or x_b$ 与 $¬x_a or ¬x_b$; 强制文字 $L$ 成立只需连 $¬L->L$. 当前 Tarjan 模板在 SCC 出栈时递增编号, 编号越小越靠近汇点, 因而当 $T_i$ 所在 SCC 的编号小于 $F_i$ 所在 SCC 的编号时令 $x_i=1$.
]


=== 边双

#code-info(
  [`work(n,edge,color)` 对无向图进行边双连通分量染色并返回分量数；一条无向边的两个邻接项须共用同一边号。],
  [时间 $O(n+m)$，额外空间 $O(n)$，递归栈最深 $O(n)$。],
)
#code-file("code/graph/tarjan2.cpp")

=== 点双

#code-info(
  [`work(n,edge,scc)` 枚举简单无向图的点双连通分量，顶点表写入 `scc` 并返回分量数；割点可出现在多个分量中。],
  [时间 $O(n+m)$；工作空间 $O(n)$，计入输出为 $O(n+m)$。],
)
#code-file("code/graph/tarjan3.cpp");

== 生成树

=== Prim

#h(2em) 维护点集 $S$, 表示已经加入生成树的点; 令 $d_v$ 表示点 $v$ 到 $S$ 的最小边权, 并记录对应的边. 任取一点 $s$ 作为起点, 令 $d_s=0$, 其余点的 $d$ 均为 $oo$. 重复以下过程:

1. 在所有不属于 $S$ 的点中, 选取 $d$ 最小的点 $u$.
2. 若 $d_u=oo$, 说明原图不连通, 不存在最小生成树; 否则将 $u$ 加入 $S$, 并在 $u!=s$ 时将其对应的边加入生成树.
3. 枚举 $u$ 的所有相邻边 $(u,v,w)$, 对每个 $v in.not S$ 用 $w$ 更新 $d_v$ 及其对应边.
4. 直到所有点均加入 $S$, 所选的 $n-1$ 条边即构成最小生成树.

#h(2em) 使用邻接矩阵朴素实现的复杂度为 $O(n^2)$; 使用邻接表和堆优化的时间复杂度为 $O((n+m)log n)$, 分别适合稠密图和稀疏图.

=== Kruskal

#code-info(
  [`work(n,edge)` 接收 `{u,v,w}` 边集，返回最小生成森林的所选边；仅在图连通时结果为 MST。],
  [时间 $O(n+m log(n+m))$，因复制并排序边集，额外空间 $O(n+m)$。],
)
#code-file("code/graph/kruskal.cpp")

==== 应用: Kruskal 重构树

#h(2em) 为每个边添加一个点, 假定图中有 $n$ 个点和 $m$ 条边, 那么可以令第 $i$ 条边的编号为 $n+i$ , 每次 Kruskal 算法加入一条边 $e(u,v)$ 的时候, 用并查集分别求出 $u,v$ 的根节点$"zuxian"(u),"zuxian"(v)$ 之后将节点 $n+e$ 作为 $"zuxian"(u),"zuxian"(v)$ 的祖先, 并在重构树中加入 $(n+e,"zuxian"(u)),(n+e,"zuxian"(v))$ 两条边. 则重构出来的树就是 Kruskal 重构树 $cal(T)$, 它满足如下的性质:\ \ 
#property[
1. $cal(T)$ 是一棵二叉树.
2. 对于任意的节点 $i,j(<=n)$ , 假定他们的公共祖先 $"LCA"(i,j)$ 对应的边的边权为 $w$ , 那么所有最小生成树方案中, 使得 $i,j$ 联通当且仅当允许加入边权 $<=w$ 的边, 这个东西可以用来快速求最小生成树上两点间的最大边的权值.
]

=== Boruvka

#h(2em) 维护当前最小生成森林的连通块, 初始时每个点各自成块. 重复执行以下过程:

1. 清空每个连通块记录的最小出边.
2. 遍历所有边 $(u,v,w)$; 若 $u,v$ 不在同一连通块, 则用该边更新两端连通块的最小出边.
3. 依次加入各连通块的最小出边; 若边的两端此时仍不连通, 就将其加入生成森林并合并两端.
4. 若本轮没有发生合并则结束; 连通图最终得到最小生成树, 非连通图最终得到最小生成森林.

#h(2em) 每条被选中的边都是某个割的最小边, 因而可以由割性质加入答案. 每轮后连通块数量至少减半, 共进行 $O(log N)$ 轮; 每轮遍历所有边, 时间复杂度为 $O(M log N)$.


=== 可撤销并查集

#code-info(
  [`DSU(n)`/`dsu_init(n)` 初始化；`find` 查根；`merge` 按大小合并；`undo` 撤销最近一次成功合并；`newnode` 增点。],
  [初始化 $O(n)$；`find/merge` 最坏 $O(log n)$，`undo` 为 $O(1)$，`newnode` 摊还 $O(1)$；空间 $O(n)$。],
)
#code-file("code/graph/undodsu.cpp")

= 网络流 / Flow

== 算法

=== 网络最大流

#code-info(
  [`dinic(n,s,t)` 初始化；`addedge(u,v,cap)` 加容量边；`solve()` 返回最大流并保留最终残量网络。],
  [一般图时间 $O(n^2m)$，空间 $O(n+m)$；要求单次 DFS 的流量上界 `inf` 不小于最大流。],
)
#code-file("code/graph/dinic.cpp")

=== 最小费用最大流

#code-info(
  [`ssp(n,s,t)` 初始化；`addedge(u,v,cap,cost)` 加边；`solve()` 返回 `{最大流,最小费用}` 并修改残量网络。],
  [整数容量下最坏时间 $O(F n m)$（$F$ 为最大流），空间 $O(n+m)$。],
)
#code-file("code/graph/mcmf.cpp")

==== 应用: 最小费用可行流

#h(2em) 在最小费用最大流中将循环的退出条件改为 cost $>=$ 0 即可.

==== 应用: 最大费用最大流

#h(2em) 将边权全部乘以 $-1$ 即可.

=== 上下界网络流

*约定*: 设边 $(u,v)$ 的流量下界和上界分别为 $b(u,v),c(u,v)$, 则合法流满足 $b(u,v)<=f(u,v)<=c(u,v)$, 并且除源汇外各点流量守恒.

==== 无源汇上下界可行流

#h(2em) 先令每条边 $(u,v)$ 流过 $b(u,v)$, 并将其容量改为 $c(u,v)-b(u,v)$. 令
$
  Delta(v):=sum_((u,v) in E)b(u,v)-sum_((v,w) in E)b(v,w),
$
若 $Delta(v)>0$, 加边 $(S',v,Delta(v))$; 若 $Delta(v)<0$, 加边 $(v,T',-Delta(v))$. 原网络存在可行流当且仅当 $S'$ 到 $T'$ 的最大流等于 $sum_(Delta(v)>0)Delta(v)$; 此时原边流量为下界加上新图中对应边的流量.

==== 有源汇上下界可行流

#h(2em) 设源汇为 $S,T$, 加入下界为 $0$, 上界为 $inf$ 的人工边 $T->S$, 再求无源汇上下界可行流. 若有解, 记人工边的流量为 $f_0$, 它就是当前 $S$ 到 $T$ 的流量. 后续保留当前残量网络, 并删除与 $S',T'$ 相连的边和人工边 $T->S$ 的正反残量边.



==== 有源汇上下界最大流

#h(2em) 求出可行流并删除附加边后, 在残量网络中求 $S$ 到 $T$ 的最大流 $Delta f$, 则最大流的答案为 $f_0+Delta f$.
#ps[
  这里的附加边是指为求可行流临时加入的 $S'->v,v->T'$ 和人工边 $T->S$, 包括它们的反向残量边. 求出可行流后应将这些边全部删除, 只保留原图各边的残量网络. 特别地, 人工边流过 $f_0$ 后会产生容量为 $f_0$ 的反向边 $S->T$; 若不删除, 第二次最大流会把撤销人工边的流量误当成新增流量. 原图边的反向残量边仍用于调整可行流, 不能删除.
]

==== 有源汇上下界最小流

#h(2em) 求出可行流并删除附加边后, 在残量网络中求 $T$ 到 $S$ 的最大流 $Delta f$, 则最小流的答案为 $f_0-Delta f$.



== 常见建模

== 模拟费用流(反悔贪心)


= 数据结构 / Data Structure

== 树状数组

#code-info(
  [`BitTree(n)` 初始化；`add(x,d)` 单点加；`ask(x)` 求前缀和；`find(v)` 在权值非负时求最小的前缀和不小于 $v$ 的位置。],
  [初始化与空间 $O(n)$；三种操作均为 $O(log n)$ 时间、$O(1)$ 额外空间；当前 `add` 的循环条件会漏掉下标 $n$。],
)
#code-file("code/data-structure/bittree.cpp")

== 线段树系列

=== 主席树

#code-info(
  [`modify` 从旧根派生单点加版本并返回新根；`query` 求两版本之差的区间和；`kth` 求版本差中的第 $k$ 小；`clone/val/pushup` 为节点辅助接口。],
  [设值域大小为 $U$：修改、查询、`kth` 均为 $O(log U)$；每次修改新增 $O(log U)$ 节点，$M$ 次修改后空间 $O(M log U)$。],
)
#code-file("code/data-structure/jtree.cpp")

=== 可裂&可并线段树

#code-info(
  [`modify/query/find` 分别完成单点加、区间和、第 $k$ 小；`merge` 破坏性合并；`split` 按 $x$ 拆成值域 $<x$ 与 $>=x$ 两棵树；其余为建点与维护接口。],
  [值域大小为 $U$ 时，前三者与 `split` 为 $O(log U)$；`merge` 为 $O(min(A_p,A_q))$；已分配 $A$ 个节点时空间 $O(A)$。],
)
#code-file("code/data-structure/sgmTree.cpp")

=== 线段树二分

#code-info(
  [`max_right(...,ql,s,v)`/`min_left(...,qr,s,v)` 分别向右/左寻找累计和首次达到 $v$ 的位置，要求区间和具有单调性。],
  [正确实现时单次时间与递归栈均为 $O(log n)$；当前 `max_right` 的整段判定方向写反，结果与复杂度暂无保证。],
)
#code-file("code/data-structure/sgtBisearch.cpp")

=== 势能线段树

#h(2em)准确来讲, 势能线段树并不是某种功能实现范式, 而是通过赋予线段树节点势能的方式来证明某些在线段树上的"暴力"操作的时间复杂度是合法的. 以下提供若干势能线段树的例子.\ \ 

#let hr = line(length: 100%)

#example[1][
  维护序列 $chevron a_i chevron.r$, 支持
  1. 给出 $l,r,v$ , 对全体 $i in [l,r]$ 执行 $a_i <- min(a_i,v)$ .
  2. 给出 $x,v$ , 执行 $a_x <- v$ .
  3. 给出 $l,r$ , 回答 $sum_(i in[l,r]) a_i$

  *solution:* 线段树的节点维护区间权值和 sum , 最大值 max#sub[1] , 次大值 max#sub[2] 以及最大值的个数 cnt ; 懒标记维护上一次 pushdown 之后在这个节点上进行的操作1的 $v$ 的最小值. 我们只考虑维护操作 1 , 首先把修改分解为散块, 如果 $v>=max_1$ 则不作修改; 若 $max_1>v>max_2$ 则在懒标记上修改; 若 $max_2>=v$ 则递归下去.\
  #h(2em)我们定义每个节点的势能是这个节点掌管的区间中有多少不同的数, 整棵树的势能是全体节点的势能之和. 每次单点修改会使得总势能增加 $O(log N)$ , 初始势能为 $O(N log N)$ , 每次(分解后的)递归操作会使得递归下去的那个节点的势能至少减少 $1$ 因此递归的总次数不超过 $O(N log N)$ .
]

#example[2][
  维护序列 $chevron a_i (<=10^9) chevron.r$, 支持
  1. 给出 $l,r,v$ , 对全体 $i in [l,r]$ 执行 $a_i <- gcd(a_i,v)$ .
  2. 给出 $x,v$ , 执行 $a_x <- v$ .
  3. 给出 $l,r$ , 回答 $sum_(i in[l,r]) a_i$

  *solution:* 对每个节点维护区间和 sum , 区间最小公倍数 lcm , 区间最小值 min ; 懒标记维护上一次 pushdown 之后在这个节点进行操作1的值 $v$ 的最大公约数. 每次操作 1 把修改分解为整块后, 对每个整块判断是否有 $lcm|v$ , 若 $lcm|v$ 则检查是否有 $min=lcm$ , 若是则直接在懒标记上修改, 若不是则递归下去.
  \
  #h(2em)我们定义每个节点的势能为 $log lcm$ , 同时我们称一个节点是有效的当且仅当不存在它的祖先满足 $lcm=min$ (相当于一个区间都是同一个值那就把它的子树全部都砍掉了), 之后整棵树的势能是有效节点的势能之和. 每次单点会增加 $O(log N)$ 个有效点, 并且使得 $O(log N)$ 个点的势能增加 $O(log V)$ , 则总势能至多增加 $O(log N log V)$ , 初始的势能是 $O(N log V)$ 的, 每次递归下去会使得此节点的 $lcm$ 至少除以 $2$ , 因此势能至少减少 $1$ , 所以总的递归次是是 $O(N log N log V)$ 的.
]

=== 历史版本和问题

== FHQ_Treap

#code-info(
  [`split/merge` 按值分裂与合并；`insert/remove` 增删一个值；`rank/kth/pre/nxt` 求排名、第 $k$ 小、严格前驱与后继；`size/clear/reserve` 管理容器。],
  [除 `size/empty` 为 $O(1)$ 外，核心操作期望 $O(log n)$、最坏 $O(n)$；删除不回收节点，空间按历史最大已分配节点数计。],
)
#code-file("code/data-structure/fhqtreap.cpp")

= 数学 / Math

== 组合数学

=== 错位排序

#definition[
  错排第 $n$ 项 $D_n$ 就是长度为 $n$ 的满足 $P_i!=i$ 的排列 $P$ 的数量.
]\ 
有两种求解错排的方式.\ \ 
#theorem[递推][
  $ 
  D_n=cases(
    1 &#strong[if] n=0,
    0 &#strong[if] n=1,
    (n-1)(D_(n-1)+D(n-2)) &#strong[otherwise]
  )
   $
]
#theorem[容斥][
  $ D_n=n!sum_(k=0)^n (-1)^k/k! $
]

=== 卡特兰数与翻折定理

#definition[组合][
  卡特兰数第 $n$ 项 $C_n$ 就是有 $n$ 对括号的合法括号序列的数量.
]\

从其组合定义出发可以获得卡特兰数有若干性质.\ \ 

#property[1][
  $ C_n=cases(
    1 &#strong[if] n=0,
    sum_(i<n)C_i dot C_(n-1-i) &#strong[otherwise]
  ) $
]
#property[2][
  有许多组合对象计数的结果也是卡特兰数:
  1. 从 $(0,0)$ 走到 $(n,n)$ 且不经过直线 $y=x+1$ 的方案数.
  2. 圆上有 $2n$ 个点, 将这些点成对连接起来且使得所得到的 $n$ 条线段两两不交的方案数.
  3. 有 $n$ 个点的不同形态的有根二叉树的个数(注意同形态递归地要求左右子树形态也相等, 并不是树同构).
  4. 将 $n$ 个 $1$ 和 $-1$ 排成一个前缀和非负的序列的方案数.
]\ 

为了更好地计算卡特兰数, 我们考虑引入翻折定理来计数 (2).1 .\ \ 
#theorem[翻折定理][
  从 $(0,0)$ 出发, 在不经过直线 $y=x+k$ 的前提下, 走到点 $(n,m)$ (要求起点和终点在直线的同一侧)的方案数为
  $
  binom(n+m,n)-binom(n+m,n+k)
  $
  相当于从 $(0,0)$ 出发不加限制地走到 $(n,m)$ 的方案数减去从 $(0,0)$ 出发不加限制地走到 $(m-k,n+k)$ (终点 $(n,m)$ 关于 $y=x+k$ 的对称点)的方案数.
]\
直接应用到卡特兰数上可以得到.\ \ 
#corollary[卡特兰数通项公式][
  $ C_n=binom(2n,n)-binom(2n,n+1) $
]
=== 斯特林数与下降/上升幂

==== 第一类斯特林数

#definition[
  第一类斯特林数第 $n$ 行第 $k(<=n)$ 列 $stl1(n,k)$ 就是将 $n$ 个两两不同的元素划分为 $k$ 个无编号的非空轮换(圆排列)的方案数.
]\
朴素的求值是通过递推式的方式来求解\ \ 

#theorem[递推][
  $ stl1(n,k)=cases(
    1 &#strong[if] n=0 and k=0,
    0 &#strong[if] n!=0 and k=0,
    stl1(n-1,k-1)+(n-1) stl1(n-1,k) &#strong[otherwise]
  ) $
]\

我们可以借助多项式乘法来求同一行/同一列的第一类斯特林数的值

#theorem[同一行第一类斯特林数][
  对于第 $n$ 行, 令 $ F(x):=product_(i=0)^(n-1)(x+i) $ 则对于 $k(<=n)$ 有 $ stl1(n,k)=[x^k]F(x) $
]
#theorem[同一列第一类斯特林数][
  对于第 $n$ 列, 令 $ F(x):=sum_(i>=1)1/i x^i $
  则对于 $k(>=n)$ 有 $ stl1(k,n)=lr([x^k/k!])F^n (x) $
]

==== 第二类斯特林数

#definition[
  第二类斯特林数第 $n$ 行第 $k(<=n)$ 列 $stl2(n,k)$ 就是将 $n$ 个两两不同的元素划分为 $k$ 个无编号非空集合的方案数.
]\ 
朴素的求值也是通过递推式和容斥两种方式来求解
#theorem[递推][
  $ stl2(n,k)=cases(
    1 &#strong[if] n=0 and k=0,
    0 &#strong[if] n!=0 and k=0,
    stl2(n-1,k-1)+k stl2(n-1,k) &#strong[otherwise]
  ) $
]
#theorem[容斥][
  $
  stl2(n,m)=sum_(i=0)^m ((-1)^(m-i))/((m-i)!)dot (i^n)/(i!) 
  $
]\
类似于第一类斯特林数, 我们还可以借助多项式乘法来求同一行/同一列的第二类斯特林数的值\ \ 

#theorem[同一行第二类斯特林数][
  对于第 $n$ 行, 令 $ F(x):=sum_i i^n/i! x^n,G(x):=sum_i (-1)^i/i! x^i$ 则对于 $i<=n$ 有 $ stl2(n,i)=[x^i](F(x) dot G(x)) $
]\
#theorem[同一列第二类斯特林数][
  对于第 $n$ 列, 令 $ F(x):=sum_(i>=1)1/i! x^i (=exp(x)-1) $ 则对于任意的 $k$ 有 $ stl2(k,n)=(lr([x^k/k!])F^n (x))/n! $
]

==== 下降/上升幂

#definition[][
  对于 $n in NN$ , 定义上升幂$ x^(overline(n))&:=product_(k=0)^(n-1)(x+k)\ &=x dot (x+1) dot ... dot (x+n-1) $类似地, 定义下降幂 $ x^(underline(n))&:=product_(k=0)^(n-1)(x-k)\ &=x dot (x-1) dot...dot (x-n+1) $
]\

借助斯特林数我们可以将上升/下降幂和普通幂转化.

#theorem[上升幂与普通幂转化][
  对于 $n in NN$ , 有 $ &x^overline(n)=sum_(k=0)^n stl1(n,k)x^k\ &x^n=(-1)^n sum_(k=0)^n (-1)^k stl2(n,k)x^overline(k) $
]\
#theorem[下降幂与普通幂转化][
  对于 $n in NN$ , 有 $ &x^n=sum_(k=0)^n stl2(n,k)x^underline(k)\ &x^underline(n)=(-1)^n sum_(k=0)^n (-1)^k stl1(n,k)x^k $
]\
#ps[
  写成交换图的话就清晰很多, 其中 sym 就是带上了 $(-1)^k$ 的系数.\ \ 
#align(center)[
  #diagram(
    cell-size: 12mm,
    $
    x^overline(n) edge("r",stl2(n,k)_"sym",->,bend: #15deg) & edge("l",stl1(n,k),->,bend: #15deg )x^n edge("r",stl1(n,k)_"sym",->,bend:#15deg) &edge("l",stl2(n,k),->,bend:#15deg) x^underline(n)\ 
    $,
  )
]
]\

下降幂的形式天然为我们描述包含组合数的式子提供了大量便利

#property[组合数][
  $ n^underline(k)&=(n!)/(n-k)!\ &=binom(n,k) k! \ \ n^overline(k)&=binom(n+k-1,k)k! $ 
]
#property[差分][
  $ Delta x^underline(k+1) &:=(x+1)^underline(k+1)-x^underline(k+1)\ &=(k+1) x^underline(k) $ 
]

=== 十二重计数

=== 容斥原理

==== 子集反演

#theorem[子集形式][
  $ &g_S=sum_(T subset.eq S)f_T, \ &f_S=(-1)^(|S|)sum_(T subset.eq S)(-1)^(|T|)g_T. $
]
#theorem[超集形式][
  $ &g_S=sum_(T supset.eq S)f_T, \ &f_S=(-1)^(|S|)sum_(T supset.eq S)(-1)^(|T|)g_T. $
]

==== 二项式反演

#theorem[前缀形式][
  $
  &g_i=sum_(j<=i)binom(i,j)f_j,\
  &f_i=(-1)^i sum_(j<=i)(-1)^j binom(i,j)g_j
  $
]
#theorem[后缀形式][
  $
  &g_i=sum_(j>=i)binom(j,i)f_j,\
  &f_i=(-1)^i sum_(j>=i)(-1)^j binom(j,i)g_j 
  $
]
#theorem[bonus: 二维形式][
  $
  &g_(i,j)=sum_(i'<=i)sum_(j'<=j)binom(i,i')binom(j,j')f_(i',j'),\
  &f_(i,j)=(-1)^(i+j)sum_(i'<=i)sum_(j'<=j)(-1)^(i'+j')binom(i,i')binom(j,j')f_(i',j')
  $
]
#ps[
  多维形式同理, 方法就是在容斥系数里堆叠地乘上对应系数的 $-1$ 次幂. 甚至可以同时存在不同的两个方向的容斥(这就是为什么前后缀要写成相同的形式, 这样可以方便合并).
]
#ps[
  多维的变换不要直接枚举, 可以参考高位前缀和那样一维一维地变换, 即先做第 $1$ 维, 再在做好的数组上做第 $2$ 维, 再在做好的数组上做第 $3$ 维 ... , 这样的话时间复杂度就是 $O(n^(k+1))$ 而非 $O(n^(2k))$ .
]
==== 斯特林反演

#theorem[前缀形式][
  $
  &g_i=sum_(j<=i)stl2(i,j)f_j,\
  &f_i=(-1)^i sum_(j<=i)(-1)^j stl1(i,j)g_j
  $
]
#theorem[后缀形式][
  $
  &g_i=sum_(j>=i)stl2(j,i)f_j,\
  &f_i=(-1)^i sum_(j>=i)(-1)^j stl1(j,i)g_j
  $
]
#ps[
  类似于二项式反演, 斯特林反演同样可以多维叠加, 且叠加的方式是一样的, 注意实现也是逐维度地去变换, 不要大力枚举.
]
==== min-max反演

#theorem[本体形式][
  对于长度为 $n$ 的序列 $chevron a_i:1<=i<=n chevron.r$ 以及集合 $S subset.eq {1,2,...,n}$ 有
  $
  min_(i in S) a_i=-sum_(T subset.eq S\ T!=emptyset)(-1)^(|T|)max_(i in T)a_i
  \
  max_(i in S) a_i=-sum_(T subset.eq S\ T!=emptyset)(-1)^(|T|)min_(i in T)a_i
  $
]\
这个东西在平凡的情形下是没什么用的, 但是它可以套在期望上, 于是可以得到一个很强大的反演公式.\ \ 
#theorem[期望版本][
  对于长度为 $n$ 的序列 $chevron a_i:1<=i<=n chevron.r$ 以及集合 $S subset.eq {1,2,...,n}$ 有
  $
  EE[min_(i in S) a_i]=-sum_(T subset.eq S\ T!=emptyset)(-1)^(|T|)EE[max_(i in T)a_i]
  \
  EE[max_(i in S) a_i]=-sum_(T subset.eq S\ T!=emptyset)(-1)^(|T|)EE[min_(i in T)a_i]
  $
]

=== 二项式定理

#theorem[二项式][
  对于 $n in NN$ 有 $ (a+b)^n=sum_(i<=n)binom(n,i)a^i b^(n-i) $
]\ 
以及高维的相关结果\ \ 
#theorem[高维][
  对于 $n in NN$ 有 $ (a_1+...+a_k)^n=sum_(i_1+...+i_k=n) binom(n,i_1,...,i_k)a_1^(i_1)dot ...dot a_k^(i_k) $ 
]

=== Lucas 定理

#h(2em) 对于质数 $p$ 而言, 我们可以快速求出组合数对 $p$ 取余数的结果.
#theorem[Lucas][
  对于 $n,m in NN$ 有 $ binom(n,m) equiv binom(n mod p, m mod p)dot binom(lr(floor n/p floor.r),lr(floor m/p floor.r)) (mod p) $
]

=== 生成函数

== 博弈论

=== 常见模型

==== Nim游戏

#problem[
共有 $n$ 堆石子, 第 $i$ 堆有 $a_i$ 枚石子. 两名玩家轮流取走任意一堆中的任意多枚石子, 但是不能不取. 取走最后一枚石子的玩家获胜
]#theorem[
  先手必败当且仅当 $ a_1 plus.o a_2 plus.o ... plus.o a_n=0 $
]

==== Bachet游戏

#problem[
  有一堆共 $n$ 枚石子, 每次取走 $1$ 至 $k$ 枚, 取走最后一枚者获胜.
]#theorem[
  先手必败当且仅当 $n equiv 0 (mod k+1)$.
]

==== 反常Nim游戏

#problem[
  共有 $n$ 堆石子, 两名玩家轮流从任意一个非空堆中取走任意正数枚石子. 与普通 Nim 不同, 取走最后一枚石子的玩家失败.
]#theorem[
  先手必败当且仅当满足以下一种情况:
  1. 所有非空堆都只有 $1$ 枚石子, 且非空堆的数量为奇数;
  2. 至少有一堆石子数大于 $1$, 且 $a_1 plus.o a_2 plus.o ... plus.o a_n=0$.
]

==== Moore's Nim-k 游戏

#problem[
  有 $n$ 堆石子, 第 $i$ 堆有 $a_i$ 枚. 每次选择 $1$ 至 $k$ 个非空堆, 分别取走任意正数枚石子, 取走最后一枚者获胜.
]#theorem[
  记 $a_i^(d)$ 为 $a_i$ 的第 $d$ 个二进制位, 则先手必败当且仅当对任意 $d>=0$ 均有
  $ sum_(i=1)^n a_i^(d) equiv 0 (mod k+1) $.
]

==== 阶梯 Nim 游戏

#problem[
  有 $n$ 堆石子, 第 $i$ 堆有 $a_i$ 枚. 每次从第 $1$ 堆取走任意正数枚石子, 或将第 $i(i>1)$ 堆的任意正数枚石子移至第 $i-1$ 堆, 取走最后一枚者获胜.
]#theorem[
  先手必败当且仅当奇数编号堆的石子数异或和为 $0$, 即
  $ a_1 ⊕ a_3 ⊕ ... ⊕ a_(n-1+(n mod 2))=0 $.
]

==== Fibonacci Nim 游戏

#problem[
  有一堆共 $n$ 枚石子. 第一次可取任意正数枚但不能取完; 此后每次至多取上一次取走数量的两倍, 取走最后一枚者获胜.
]#theorem[
  先手必败当且仅当 $n$ 是 Fibonacci 数.
]

==== Wythoff 游戏

#problem[
  有两堆石子, 数量分别为 $a_1,a_2$. 每次可从一堆取走任意正数枚, 或从两堆各取走相同的正数枚, 取走最后一枚者获胜.
]#theorem[
  不妨设 $a_1<=a_2$, 令 $phi=(sqrt(5)+1)/2$, 则先手必败当且仅当
  $ a_1=lr(floor (a_2-a_1)phi floor.r) $.
]

=== SG理论

#let mex=math.op("mex")
#let SG=math.op("SG")

==== 基本定义

#definition[公平组合游戏][
  两名玩家轮流操作, 同一状态下双方可选的操作完全相同, 且游戏必在有限步内结束. 以下只考虑正常规则, 即无法操作的玩家失败.
]
#definition[$mex$ 与 SG 函数][
  定义 $mex(S):=min {x in NN:x in.not S}$, 即 $S$ 中没有出现的最小非负整数, 特别地 $mex(emptyset)=0$.
  记状态 $x$ 的后继状态集合为 $F(x)$, 则
  $ SG(x)=mex({SG(y):y in F(x)}) $.
]
#theorem[胜负判定][
  $SG(x)=0$ 当且仅当 $x$ 为先手必败状态; $SG(x)!=0$ 当且仅当 $x$ 为先手必胜状态. 特别地, 终止状态的 SG 值为 $0$.
]

==== SG 定理

#definition[游戏的和][
  若游戏由若干个互不影响的子游戏组成, 每次操作只选择其中一个子游戏行动, 则称整体为这些子游戏的和.
]
#theorem[Sprague--Grundy][
  任意有限的正常规则公平组合游戏都等价于一堆大小为其 SG 值的 Nim 游戏. 对于相互独立的子游戏 $G_1,G_2,...,G_n$, 有
  $ SG(G_1+G_2+...+G_n)=SG(G_1) plus.o SG(G_2) plus.o ... plus.o SG(G_n) $.
  因此所有子游戏 SG 值的异或和为 $0$ 时先手必败, 否则先手必胜.
]

==== 求解方法

1. 将游戏拆成相互独立的子游戏, 明确每个状态及其所有后继状态.
2. 用记忆化搜索或逆拓扑序, 从终止状态开始对后继状态的 SG 值取 $mex$.
3. 将初始局面中各子游戏的 SG 值异或, 根据异或和是否为 $0$ 判断胜负.

#ps[
  若一次操作把一个游戏拆成若干个独立部分, 应先将这些部分的 SG 值异或, 再把所得结果放进当前状态的 $mex$ 集合. 反常规则、双方可选操作不同或游戏可能无限进行时, 不能直接套用 SG 定理.
]

== 数论

=== $mu$-反演与Dirichlet卷积

==== $mu$-反演
#h(2em) 对于一些数论函数我们直接计算他们是很困难的, 但是相对而言计算他们的约数项的和或者倍数项的和却很容易, 那么就可以借助整除序 $(NN,|)$ 上的 $mu$ (即莫比乌斯函数)来帮助我们反演.\ \ 
#theorem[$mu$-反演, 约数和版本][
  $
  &g(n)=sum_(d|n)f(d),
  \
  &f(n)=sum_(d|n)mu(n/d)g(d)
  $
]
#theorem[$mu$-反演, 倍数和版本][
  $
  &g(n)=sum_(n|d)f(d),
  \
  &f(n)=sum_(n|d)mu(d/n)g(d)
  $
]
#ps[
  莫比乌斯反演本质上是在整除偏序上的容斥原理, 因此类似的, 它也有多维反演的形式, 并且和前面容斥原理里的多维反演的形式是一样的.
]
==== Dirichlet卷积与积性函数

#definition[Dirichlet卷积][
  对于数论函数 $f,g:NN->NN$ , 定义他们的Dirichlet卷积
  $
  f*g:&NN->NN\ &n mapsto sum_(d|n)f(d)dot g(n/d)
  $
]\ 
#definition[积性函数][
  称一个数论函数 $f:NN->NN$ 是积性函数当且仅当对于 $n,m in NN$ , 若 $gcd(n,m)=1$ 则 $f(n)dot f(m)=f(n dot m)$ 成立.
]\
#definition[完全积性函数][
  称一个数论函数 $f:NN->NN$ 是完全积性函数当且仅当对于任意的 $n,m in NN$ , 均有 $f(n)dot f(m)=f(n dot m)$ 成立.
]\
#h(2em) 根据积性函数的定义, 我们可以把每个积性函数一一对应为一个 $PP times NN -> NN$ 的函数. 这本质的原因是每个数的素因子分解是唯一的, 对于积性函数 $f$ 以及自然数 $n$ 而言, 假定 $n$ 的质因子分解为$ n=p_1^(a_1)times p_2^(a_2)times ...times p_k^(a_k) $ 那么可以直接得到 $ f(n)=f(p_1^(a_1))times f(p_2^(a_2))times ... times f(p_k^(a_k)) $ 因此我们只需要为每个 $p in PP$ 以及 $n in NN$ 指派 $f(p^n)$ 的值即可.

#h(2em) 对于完全积性函数 $g$ , 我们只需要指派 $g(p)$ 的值即可, 因为 $g(p^n)=g(p)^n$ .

=== Extended GCD

#code-info(
  [`exgcd(x,y)` 返回 `{g,u,v}`，满足 $g=gcd(x,y)=u x+v y$。],
  [时间与递归栈空间均为 $O(log min(|x|,|y|))$。],
)
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

#code-info(
  [`BSGS(a,b,p,k)` 在 $gcd(a,p)=1$ 时求最小的 $x>=0$ 使 $k a^x equiv b mod p$；`exBSGS(a,b,p)` 去除互质限制；无解返回 `-1`。],
  [哈希表操作按期望 $O(1)$ 计，时间与空间均为 $O(sqrt(p))$。],
)
#code-file("code/math/bsgs.cpp")

=== CRT & exCRT

#code-info(
  [`CRT(sym)` 合并两两互质的同余式；`merge(x,y)` 合并两个一般同余式并原地修改 `x`；`exCRT(sym)` 处理非互质模数，无解返回 `-1`。],
  [设同余式数为 $k$、最终模数为 $M$：时间 $O(k log M)$；参数按值复制及递归栈共占 $O(k+log M)$ 空间。],
)
#code-file("code/math/crt.cpp")

=== 线性筛素数&积性函数

#code-info(
  [`work(N,prime,low,f)` 筛出 $[2,N)$ 的素数；`low[x]` 为最小质因子的最高幂，补全质数幂处代码后同时计算积性函数 `f`。],
  [时间 $O(N)$，输出及辅助空间 $O(N)$。],
)
#code-file("code/math/linearSieve.cpp")

=== 整除与数论分块

#h(2em) 对于 $n in NN$ , 定义 $ D(n):={lr(floor n/i floor.r):1 <= i <= n} $
则 $D(n)$ 有如下的性质\ \ 
#property[1][
$|D(n)|=Theta(sqrt(n))$ , 更精确地, $ |D(n)|=floor sqrt(4n+1)floor.r-1 $
]
#property[2][
  对于 $d in D(n)$ , 能够使得 $lr(floor n/i floor.r)=d$ 的 $i$ 是连续的, 更准确地, 这样的 $i$ 的取值范围是$ lr(floor n/(d+1)floor.r)<i<=lr(floor n/(d+1)floor.r) $
]
#corollary[2][
  对于多元数论分块 $ lr(chevron lr(floor n_1/i floor.r),lr(floor n_2/i floor.r),...,lr(floor n_k/i floor.r) chevron.r) $ 它本质上只有 $O(|D(n_1)|+...+|D(n_k)|)$ 种取值(而非 $O(|D(n_1)|times...times|D(n_k)|)$ 种).
]
#property[3][
  对于 $m in D(n)$ , 有 $ D(m) subset.eq D(n) $ 
]\
#h(2em) 我们还有若干整除的性质, 包括但不限于\ \ 
#property[1][
  对于 $n,x,y in NN$ 有 $ lr(floor lr(floor n/x floor.r)/ y floor.r)=lr(floor n/(x y) floor.r) $
]\
以及上下取整的转化\ \ 
#property[2][
  对于 $n,m in NN$ , 有 $ lr(ceil n/m ceil.r)=lr(floor (n-1)/m floor.r)+1 $
]

=== 杜教筛

==== 实现
#code-info(
  [`DuJiao_sieve(inv_g,S_g,S_fg)` 设置 $g(1)^{-1}$ 及两个前缀和函数；`calc(n,pre)` 记忆化计算 $sum_(i<=n)f(i)$。],
  [标准取预处理界 $B=Theta(n^(2/3))$ 时，期望时间与总空间均为 $O(n^(2/3))$。],
)
#code-file("code/math/Du'sSieve.cpp")

==== 常见的构造列表

=== Min_25筛



=== 类欧几里得方法

== 多项式

=== 复数FFT

#code-info(
  [`cmplx` 提供复数四则所需操作；`fft(f,tag)` 原地执行长度为二次幂的 DFT（`tag=0`）或 IDFT（`tag=1`）。],
  [长度为 $n$ 时，时间 $O(n log n)$，除输入数组外额外空间 $O(1)$。],
)
#code-file("code/math/fft.cpp")

=== 取模全家桶
#code-info(
  [`poly` 提供长度调整、下标访问、NTT/INTT、加减乘、求逆与求导；`integral()` 预留为积分接口，但当前实现尚未完成。],
  [加减与求导为 $O(n)$；变换、乘法及求逆为 $O(n log n)$；工作空间 $O(n)$。当前文件因 `integral()` 未完成而不能编译。],
)
#code-file("code/math/poly(mod).cpp")

= 杂项

== Millar-Rabin素性测试

#code-info(
  [`MillerRabin::test(n)` 使用固定七组底数判定 64 位整数 $n$ 是否为质数。],
  [时间 $O(log n)$，额外空间 $O(1)$；模乘必须使用足够宽的类型以避免乘法溢出。],
)
#code-file("code/math/mr.cpp")

== 线性代数类

#code-info(
  [构造器建立常数矩阵或单位阵；`[]/n()/m()` 访问元素与尺寸；`+,-,*`、`fpow` 完成矩阵运算；`gauss/det/inv` 求消元结果、行列式与逆矩阵。],
  [$n times k$ 乘 $k times m$ 为 $O(n k m)$；$n times m$ 消元为 $O(n^2 m)$；方阵快速幂 $O(n^3 log t)$，行列式与求逆 $O(n^3)$；空间 $O(n m)$。],
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
  [`VirtualTree(DFN,DEP,lca,root)` 保存原树信息；`work(Nd,tree,lnk)` 建立重新编号的虚树，返回点数，`lnk` 映射回原树。],
  [关键点数为 $k$、单次 LCA 为 $L$ 时，构造对象 $O(n)$，单次建树 $O(k log k+k L)$；对象空间 $O(n)$、单次输出空间 $O(k)$。],
)
#code-file("code/graph/virtualtree.cpp")

== 拉格朗日插值

#code-info(
  [`insert(x,y)` 加入采样点并返回新增/重复/冲突状态；`find(u)` 求插值多项式在 $u$ 处的值；`fast_construct(l,y)` 快速建立连续横坐标采样点。],
  [已有 $k$ 个点、模数为 $p$ 时，插入 $O(k)$、单点求值 $O(k log p)$、连续点构造 $O(k)$；存储空间 $O(k)$。],
)
#code-file("code/math/lagrange.cpp")

== LGV引理

== 高精度

寫你撚個臭閪嘅高精度，去寫 python 喇黐線。

== 高位前缀和/差分

#code-info(
  [`sum_of_subset(n,f,sum)` 求所有子集和；`diff_of_subset(n,f,diff)` 对其进行 Möbius 逆变换。],
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

= 检查表 / Checklist

#include "notes/checklist.typ"
