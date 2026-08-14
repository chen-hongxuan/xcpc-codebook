#import "@preview/theorion:0.6.0": *
#import cosmos.fancy: *   // 选择 fancy 主题样式
#let theorem = theorem.with(numbering: none)
#let corollary = corollary.with(numbering: none)
#let property = property.with(numbering: none)
#let definition = definition.with(numbering: none)
#let example = example.with(numbering: none)

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

#code-file("code/basic/chk_template.cpp");

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

== 线段树系列

=== 主席树

#code-file("code/data-structure/jtree.cpp")

=== 可裂&可并线段树

#code-file("code/data-structure/sgmTree.cpp")

=== 线段树二分

#code-file("code/data-structure/sgtBisearch.cpp")

=== 势能线段树

#h(2em)准确来讲, 势能线段树并不是某种功能实现范式, 而是通过赋予线段树节点势能的方式来证明某些在线段树上的"暴力"操作的时间复杂度是合法的. 以下提供若干势能线段树的例子.

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

#code-file("code/data-structure/fhqtreap.cpp")

= 数学 / Math

== 组合数学

=== 错位排序

#definition[
  错排第 $n$ 项 $D_n$ 就是长度为 $n$ 的满足 $P_i!=i$ 的排列 $P$ 的数量.
]\ 
有两种求解错排的方式.
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

从其组合定义出发可以获得卡特兰数有若干性质.

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

为了更好地计算卡特兰数, 我们考虑引入翻折定理来计数 (2).1 .
#theorem[翻折定理][
  从 $(0,0)$ 出发, 在不经过直线 $y=x+k$ 的前提下, 走到点 $(n,m)$ (要求起点和终点在直线的同一侧)的方案数为
  $
  binom(n+m,n)-binom(n+m,n+k)
  $
  相当于从 $(0,0)$ 出发不加限制地走到 $(n,m)$ 的方案数减去从 $(0,0)$ 出发不加限制地走到 $(m-k,n+k)$ (终点 $(n,m)$ 关于 $y=x+k$ 的对称点)的方案数.
]\
直接应用到卡特兰数上可以得到.
#corollary[卡特兰数通项公式][
  $ C_n=binom(2n,n)-binom(2n,n+1) $
]
=== 斯特林数与下降/上升幂

==== 第一类斯特林数

#definition[
  第一类斯特林数第 $n$ 行第 $k(<=n)$ 列 $stl1(n,k)$ 就是将 $n$ 个两两不同的元素划分为 $k$ 个无编号的非空轮换(圆排列)的方案数.
]\
朴素的求值是通过递推式的方式来求解

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
类似于第一类斯特林数, 我们还可以借助多项式乘法来求同一行/同一列的第二类斯特林数的值

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
这个东西在平凡的情形下是没什么用的, 但是它可以套在期望上, 于是可以得到一个很强大的反演公式.
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
以及高维的相关结果
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

== 数论

=== $mu$-反演与Dirichlet卷积

==== $mu$-反演
#h(2em) 对于一些数论函数我们直接计算他们是很困难的, 但是相对而言计算他们的约数项的和或者倍数项的和却很容易, 那么就可以借助整除序 $(NN,|)$ 上的 $mu$ (即莫比乌斯函数)来帮助我们反演.
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
==== Dirichlet卷积与积性函数

#definition[Dirichlet卷积][
  对于数论函数 $f,g:NN->NN$ , 定义他们的Dirichlet卷积
  $
  f*g:&NN->NN\ &n mapsto sum_(d|n)f(d)dot g(n/d)
  $
]
#definition[积性函数][
  数论函数 $f:NN->NN$ 是积性函数当且仅当对于 $n,m in NN$ , 若 $gcd(n,m)=1$ 则 $f(n)dot f(m)=f(n dot m)$ 成立.
]\
根据积性函数的定义, 我们
#theorem[
  
]


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

=== 整除与数论分块

#h(2em) 对于 $n in NN$ , 定义 $ D(n):={lr(floor n/i floor.r):1 <= i <= n} $
则 $D(n)$ 有如下的性质
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
#h(2em) 我们还有若干整除的性质, 包括但不限于
#property[1][
  对于 $n,x,y in NN$ 有 $ lr(floor lr(floor n/x floor.r)/ y floor.r)=lr(floor n/(x y) floor.r) $
]\
以及上下取整的转化
#property[2][
  对于 $n,m in NN$ , 有 $ lr(ceil n/m ceil.r)=lr(floor (n-1)/m floor.r)+1 $
]

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

== Millar-Rabin素性测试

#code-file("code/math/mr.cpp")

== 线性代数类

#code-file("code/math/matrix.cpp")

== matrix-tree定理

=== 无向图

#h(2em) 设无向多重图 $G(V,E)$ 有 $n$ 个顶点, 那么我们构造如下矩阵 $(D_(i j))_(n times n)$
$ &D_(i j):=cases(
  deg(i) &#strong[if] i=j,
  -|E(i,j)| &#strong[otherwise]
) $
则我们有定理
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
则可以类似地导出有向图上的矩阵树定理
#theorem[有向图,根向树][
  对于 $1<=i<=n$ , 设将 $D^"out"$ 去掉第 $i$ 行第 $i$ 列得到的子矩阵为 $D^"out"_((i))$ , 则 $G$ 上的以 $i$ 为根的且所有边都指向根节点的全体生成树构成的集合 $tau^"root" (G,i)$ 满足$ |tau^"root" (G,i)|=det D^"out"_((i)) $
]
#theorem[有向图,叶向树][
  对于 $1<=i<=n$ , 设将 $D^"in"$ 去掉第 $i$ 行第 $i$ 列得到的子矩阵为 $D^"in"_((i))$ , 则 $G$ 上的以 $i$ 为根的且所有边都指向叶子的全体生成树构成的集合 $tau^"leaf" (G,i)$ 满足$ |tau^"leaf" (G,i)|=det D^"leaf"_((i)) $
]
=== 带权形式
#h(2em) 边 $e$ 有边权 $w(e)$ , 定义树 $T$ 的权值 $ w(T):=product_(e in T)w(e) $  则对于全体生成树的权值和 $ sum_(T in tau(G,i))w(T) $ 我们只需要把一个权重为 $w(e)$ 的边看成 $w(e)$ 重边即可.

== Hall定理

#h(2em) 对于一个二分图 $G(A,B,E)$ , 不妨设 $|A|<=|B|$ , 则*Hall定理*可以判定完美匹配是否存在.

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

这样我们就得到了一个长度为 $n-2$ 的序列, 可以验证这个映射是双射. 借助这个双射我们可以得到若干结果

#theorem[Cayley公式][
  完全图(有标号) $K_n$ 的生成树数量为 $ n^(n-2) $
]
#corollary[][
  一个 $n$ 个点的带标号无向图, 它有 $k$ 个连通块, 我们希望添加 $k-1$ 条边使得整个图连通, 假定第 $i$ 个连通块里有 $s_i$ 个顶点, 那么添加边的方案数是$ n^(k-2)product_(i=1)^k s_i $
]
== 虚树

#code-file("code/graph/virtualtree.cpp")

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
