#import "../common.typ": *

= 杂项

== Miller-Rabin 素性测试

#code-info(
  [`MillerRabin::test(n)` 使用固定七组底数判定 `long long` 范围内的非负整数 $n$ 是否为质数, 质数返回 $1$ , 否则返回 $0$ . ],
  [时间 $O(log n)$ , 额外空间 $O(1)$ ; 代码已使用 `__int128` 完成安全模乘. ],
)
#code-file("code/math/mr.cpp")

== 线性代数类

#include "../code/matrix/matrix.typ"

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
#h(1em) (1). 选择一个当前的树中的标号最小的叶子节点 $x$ .\
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
  [`VirtualTree(DFN,DEP,lca,root)` 保存同一棵有根树的信息; `work(Nd,tree,lnk)` 建立虚树并返回点数, 其中 `tree[u]` 记录虚树儿子, `lnk[u]` 映射回原树, 虚树根编号为 $1$ . 要求关键点互异且均在 `root` 子树内; `Nd` 按值传入, 原顺序不变. ],
  [设关键点数为 $k$ 、单次 LCA 为 $L$ , 初始化时间和空间 $O(n)$ ; 单次建树 $O(k log k+k L)$ , 输出空间 $O(k)$ . ],
)
#code-file("code/graph/virtualtree.cpp")

== 拉格朗日插值

#code-info(
  [`insert(x,y)` 加入采样点, 返回 $1/0/-1$ 分别表示新增、完全重复、同横坐标取值冲突; `find(u)` 求插值多项式在 $u$ 处的值并自动归一化 $u$ ; `fast_construct(l,y)` 建立横坐标为 $l,l+1,dots$ 的采样点. 须将 `_P_` 换成质数, 保证存入的坐标在 `[0,mo)` 且横坐标模意义下互异. ],
  [已有 $k$ 个点、模数为 $p$ 时, 插入 $O(k)$ 、单点求值 $O(k log p)$ 、连续点构造 $O(k)$ ; 存储空间 $O(k)$ . ],
)
#code-file("code/math/lagrange.cpp")

== LGV引理


#problem[
设有穷带权 DAG $G$ 中有两组互异顶点 $A_1,...,A_k$ 与 $B_1,...,B_k$ . 路径 $P$ 的权值为 $w(P)=product_(e in P)w(e)$ ; 无权计数时令所有边权为 $1$ . 定义
$
  m_(i j)=sum_(P:A_i -> B_j) w(P), quad M=(m_(i j))_(k times k),
$
其中 $m_(i j)$ 是从 $A_i$ 到 $B_j$ 的所有有向路径权值和. 问题是计算若干条两两顶点不交路径组成的路径族总权值.
]

#theorem[LGV引理][
  对每个排列 $sigma in S_k$ , 记 $op("inv")(sigma)$ 为 $sigma$ 的逆序对数, $cal(P)_sigma$ 为满足 $P_i:A_i -> B_(sigma(i))$ 且两两顶点不交的路径族集合, 路径族权值为 $product_(i=1)^k w(P_i)$ . 则
  $
    det M=sum_(sigma in S_k) (-1)^(op("inv")(sigma))
    sum_((P_1,...,P_k) in cal(P)_sigma) product_(i=1)^k w(P_i).
  $
]

#corollary[赛时常用形式][
  若由平面位置、单调性或拓扑顺序可以证明, 只有恒等排列能够产生不交路径族, 则所求总权值就是 $det M$ . 更一般地, 若只有唯一排列 $sigma_0$ 可行, 则所求总权值为 $(-1)^(op("inv")(sigma_0))det M$ .
]

#ps[
  证明略. 使用时依次确定起终点顺序, 独立计算每个单路径权值和 $m_(i j)$ , 证明可行排列唯一, 最后在题目要求的数域或模数下计算 $det M$ . 若多个排列均可行, 行列式只是它们的带符号和, 不能直接当作方案总数.
]

== 高精度

寫你撚個臭閪嘅高精度, 去寫 python 喇黐線.

== 高位前缀和/差分

#code-info(
  [`sum_of_subset(n,f,sum)` 求每个集合的所有子集权值和; `diff_of_subset(n,f,diff)` 执行其 Möbius 逆变换. 要求 `f` 按二进制集合编号并至少含 $2^n$ 项; 当前 `1<<n` 的写法要求 $0<=n<31$ . ],
  [时间 $O(n 2^n)$ , 输出空间 $O(2^n)$ , 除此之外额外空间 $O(1)$ . ],
)
#code-file("code/math/sum&diff.cpp")

== 广义FWT

#definition[位运算卷积][
  设系数取自域 $K$ , $[q]:={0,...,q-1}$ , 并给定单个数位上的运算 $compose:[q] times [q]->[q]$ . 对 $x=(x_1,...,x_n),y=(y_1,...,y_n) in [q]^n$ , 定义逐位运算
  $
    x compose^* y=(x_1 compose y_1,...,x_n compose y_n).
  $
  对数组 $a,b:[q]^n->K$ , 定义它们的 $compose^*$ -卷积
  $
    c_k=sum_(i compose^* j=k) a_i b_j, quad k in [q]^n.
  $
]\ 
#problem[
  给定长度为 $q^n$ 的序列 $chevron a_i:i in [q]^n chevron.r,chevron b_i:i in [q]^n chevron.r$ , 求他们的 $compose^*$-卷积.
]#ps[直接枚举有序对 $(i,j)$ 需要 $O(q^(2n))$ 时间. 广义FWT尝试把卷积变成变换域中的逐项乘法, 从而同时求出全部 $q^n$ 个 $c_k$ .]

=== 单个数位上的矩阵构造

#theorem[局部构造条件][
  若存在 $q times q$ 矩阵 $A,B,C$ , 其中 $C$ 可逆, 且对任意 $t,i,j in [q]$ 均有
  $
    C_(t,i compose j)=A_(t,i)B_(t,j),
  $
  则在单数位上
  $
    C c=(A a) dot.o (B b),
  $
  其中 $dot.o$ 表示逐项乘法. 反之, 若此等式对任意 $a,b in K^q$ 成立, 分别取 $a=e_i,b=e_j$ 即可得到上述矩阵元素条件, 因而两者等价.
]

=== 由 $[q]$ 推广到 $[q]^n$

#h(2em) 令 $V=K^q$ , 以 $e_0,...,e_(q-1)$ 为基, 则数组空间可识别为 $K^([q]^n) ≅ V^(times.o n)$ . 定义
$
  A^*=A^(times.o n), quad
  B^*=B^(times.o n), quad
  C^*=C^(times.o n),
$
其中 $times.o$ 表示TensorProduct. 对任意 $t,i in [q]^n$ , 张量积矩阵的元素为
$
  (A^*)_(t,i)=product_(r=1)^n A_(t_r,i_r),
$
$B^*,C^*$ 同理. 局部构造条件可以逐坐标相乘:
$
  (C^*)_(t,i compose^* j)
  =product_(r=1)^n C_(t_r,i_r compose j_r)
  =product_(r=1)^n A_(t_r,i_r)B_(t_r,j_r)
  =(A^*)_(t,i)(B^*)_(t,j).
$
所以单数位结论自动提升为
$
  C^* c=(A^* a) dot.o (B^* b),
$
并且 $(C^*)^(-1)=(C^(-1))^(times.o n)$ . 因此卷积可以依次执行
$
  a'=A^*a, quad b'=B^*b, quad d=a' dot.o b', quad c=(C^(-1))^(times.o n)d.
$

=== 逐位蝶形

#h(2em) 不应显式构造 $q^n times q^n$ 的 $T^(times.o n)$ . 从低位到高位依次处理 $n$ 个数位: 第 $i$ 轮枚举低 $i-1$ 位编码 $x$ 和高 $n-i$ 位编码 $y$ , 令
$
  op("pos")(s)=x+s q^(i-1)+y q^i, quad 0<=s<q.
$
取出 $v_s=f_(op("pos")(s))$ , 计算 $w=T v$ , 再统一写回 $f_(op("pos")(s))=w_s$ . 第 $i$ 轮结束后, 数组处于混合基底
$
  f^((i))=(T^(times.o i) times.o I^(times.o (n-i)))f^((0)),
$
即前 $i$ 位已经变换, 后 $n-i$ 位仍为原下标. 全部轮次结束后即得到 $T^(times.o n)f$ .\ \ 

#code-info(
  [`fwt::work(q,n,f,T)` 原地计算 $f←T^(times.o n)f$ . 要求 `f.size()==q^n`、`T` 为 $q times q$ 矩阵, 且元素已经按 `matrix::mo` 归一化; 依赖线性代数类的主体框架. 求卷积时分别以 $A,B$ 变换两个输入并逐项相乘, 再以 $C^(-1)$ 变换乘积. ],
  [令 $N=q^n$ , 稠密矩阵下时间为 $O(n q N)$ , 额外空间为 $O(q)$ ; 当 $q$ 为常数时, 时间为 $O(N log N)$ . ],
)
#code-file("code/math/fwt.cpp")

=== 常见的 FWT 的矩阵

#text(size: 6pt)[
  #table(
    columns: (0.65fr, 1.25fr, 1.1fr, 1.1fr),
    stroke: 0.35pt + luma(150),
    inset: 2pt,
    align: center,
    [*卷积*], [*定义*], [*$A=B=C=T$*], [*$T^(-1)$*],
    [OR], [$c_k=sum_(i " OR " j=k)a_i b_j$], [$mat(1,0;1,1)$], [$mat(1,0;-1,1)$],
    [AND], [$c_k=sum_(i " AND " j=k)a_i b_j$], [$mat(1,1;0,1)$], [$mat(1,-1;0,1)$],
    [XOR], [$c_k=sum_(i " XOR " j=k)a_i b_j$], [$mat(1,1;1,-1)$], [$1/2 mat(1,1;1,-1)$],
  )
]

#h(2em) 三行分别取 $compose$ 为二进制 OR、AND、XOR, 直接验证 $T_(t,i compose j)=T_(t,i)T_(t,j)$ 即可. OR 与 AND 的变换分别是子集和与超集和; XOR 的逆变换要求 $2$ 可逆, 在模运算中通常要求模数为奇质数. 构造代码中的矩阵时, 表内的 $-1$ 与 $1/2$ 应分别写成 `mo-1` 与 `qpow(2)`.

=== 特例: 异或卷积的写法

#h(2em) XOR 的单数位矩阵满足 $T^(-1)=T/2$ . 因此每轮只需执行蝶形
$
  (u,v)->(u+v,u-v),
$
正变换和逆变换可以使用同一组蝶形; 完成 $n$ 轮后有 $(T^(times.o n))^2=2^n I=N I$ , 故逆变换最后统一乘 $N^(-1)$ 即可, 无须构造或访问 `matrix`.\ \ 

#code-info(
  [`xor_fwt::work(f,opt)` 原地执行 XOR 变换; `opt=0` 为FWT, `opt=1` 为IFWT. 要求 `f` 非空且长度 $N$ 为二次幂, 元素已经在 `[0,mo)` 内; 逆变换还要求 $N$ 在模 `mo` 下可逆. 求 XOR 卷积时对两个输入执行FWT、逐项相乘, 再执行IFWT. ],
  [时间 $O(N log N)$ , 除输入数组外额外空间 $O(1)$ . ],
)
#code-file("code/math/xor-fwt.cpp")

== 三元环计数

#definition[三元环][
  在简单无向图 $G=(V,E)$ 中, 若三个不同的点 $u,v,w$ 两两相连, 则无序三元组 $(u,v,w)$ 构成一个三元环. 三元环计数即求图中不同三元环的数量.
]\
#h(2em) 先给每条边定向: 从度数较小的点指向度数较大的点; 度数相同时, 从编号较小的点指向编号较大的点. 点的度数与编号按字典序严格增大, 因此定向后的图是一张 DAG. 随后执行:

1. 枚举每条有向边 $u->v$ .
2. 枚举 $v$ 的每条出边 $v->w$ .
3. 若原图中存在边 $(u,w)$ , 就找到一个三元环并将答案加 $1$ .\ \ 

#theorem[正确性与复杂度][
  一个三元环的三个点按上述顺序排列后, 边的方向必为 $u->v,u->w,v->w$ , 因此它恰好会被统计一次. 对任意点 $v$ , 若 $d_v<=sqrt(m)$ , 则其出度显然不超过 $sqrt(m)$ ; 否则它只能指向度数同样大于 $sqrt(m)$ 的点, 而这样的点至多有 $O(sqrt(m))$ 个. 所以每条边之后至多继续枚举 $O(sqrt(m))$ 条边, 总时间复杂度为 $O(m sqrt(m))$ .
]

== 莫队算法

== 整体二分

== CDQ分治

== 四边形不等式优化

=== 四边形不等式

#definition[四边形不等式][
  设 $w(l,r)$ 为区间 $[l,r]$ 的代价. 若对任意 $a<=b<=c<=d$ 均有
  $
    w(a,c)+w(b,d)<=w(a,d)+w(b,c),
  $
  则称 $w$ 满足四边形不等式, 其代价矩阵为Monge矩阵. 等价地,
  $
    w(a,d)-w(a,c)>=w(b,d)-w(b,c),
  $
  即向右扩展相同的一段时, 左端点越靠左, 新增代价越大.
]

#ps[
  实际证明时常先验证相邻形式
  $
    w(i,j)+w(i+1,j+1)<=w(i,j+1)+w(i+1,j),
  $
  再通过累加得到一般形式. 以下均讨论取最小值; 对最大值问题应相应反转不等号或对代价取负.
]

=== 分层DP的分治优化

#theorem[决策单调性][
  考虑转移
  $
    f_t(i)=min_(0<=j<i){f_(t-1)(j)+w(j+1,i)}.
  $
  令 $op("opt")_t(i)$ 为取得最小值的最小决策 $j$ . 若 $w$ 满足四边形不等式, 则
  $
    op("opt")_t(i)<=op("opt")_t(i+1).
  $
]

#h(2em) 计算区间 $[l,r]$ 的中点 $m$ 时, 在候选区间 $[L,R]$ 中求出 $op("opt")(m)=p$ ; 随后左半区间只搜索 $[L,p]$ , 右半区间只搜索 $[p,R]$ . 若转移代价能 $O(1)$ 计算, 每层DP由 $O(n^2)$ 降为 $O(n log n)$ , 共 $k$ 层时为 $O(k n log n)$ .

=== 区间DP的Knuth优化

#definition[区间包含单调性][
  若对任意 $a<=b<=c<=d$ 均有
  $
    w(b,c)<=w(a,d),
  $
  则称 $w$ 满足区间包含单调性.
]

#theorem[Knuth优化][
  考虑区间DP
  $
    f(l,r)=w(l,r)+min_(l<=k<r){f(l,k)+f(k+1,r)}.
  $
  若 $w$ 同时满足四边形不等式和区间包含单调性, 则可选择最优断点 $op("opt")(l,r)$ 使得
  $
    op("opt")(l,r-1)<=op("opt")(l,r)<=op("opt")(l+1,r).
  $
  因而计算 $f(l,r)$ 时只需枚举
  $
    op("opt")(l,r-1)<=k<=min(r-1,op("opt")(l+1,r)),
  $
  总时间由 $O(n^3)$ 降为 $O(n^2)$ , DP与决策数组的空间为 $O(n^2)$ .
]

#example[石子合并][
  当石子重量非负且 $w(l,r)=sum_(i=l)^r a_i$ 时, 四边形不等式取等号, 区间包含单调性也成立, 因此上述区间合并DP可以使用Knuth优化.
]
