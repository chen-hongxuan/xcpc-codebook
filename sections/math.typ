#import "../common.typ": *

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
  对于 $n in NN$ , 定义上升幂$ x^(overline(n))&:=product_(k=0)^(n-1)(x+k)\ &=x dot (x+1) dot ... dot (x+n-1) $ 类似地, 定义下降幂 $ x^(underline(n))&:=product_(k=0)^(n-1)(x-k)\ &=x dot (x-1) dot...dot (x-n+1) $
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
    $ ,
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

#definition[][
  将 $n$ 个球放入 $m$ 个盒, 每个球恰好进入一个盒. 分别考虑球与盒是否有标号, 以及盒可空且容量不限、每盒至多一球、每盒至少一球三种限制, 共得到十二类计数问题.
]

#text(size: 6pt)[
  #table(
    columns: (1.05fr, 1.45fr, 1.1fr, 1.25fr),
    stroke: 0.35pt + luma(150),
    inset: 1.2pt,
    align: center,
    [*球 / 盒*], [*可空且不限容量*], [*至多一球*], [*盒非空*],
    [有标号 / 有标号], [$m^n$ ], [$m^underline(n)$ ], [$m! stl2(n,m)$ ],
    [无标号 / 有标号], [$binom(n+m-1,m-1)$ ], [$binom(m,n)$ ], [$binom(n-1,m-1)$ ],
    [有标号 / 无标号], [$sum_(k=0)^m stl2(n,k)$ ], [$I(n <= m)$ ], [$stl2(n,m)$ ],
    [无标号 / 无标号], [$sum_(k=0)^m p_k(n)$ ], [$I(n <= m)$ ], [$p_m(n)$ ],
  )
]

#ps[
  其中 $p_k(n)$ 表示将整数 $n$ 分拆为恰好 $k$ 个正整数之和的方案数; $I(P)$ 在命题 $P$ 成立时为 $1$ , 否则为 $0$ . 约定不可行情形的组合数、斯特林数和分拆数均为 $0$ .
]


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
  先手必败当且仅当 $n equiv 0 (mod k+1)$ .
]

==== 反常Nim游戏

#problem[
  共有 $n$ 堆石子, 两名玩家轮流从任意一个非空堆中取走任意正数枚石子. 与普通 Nim 不同, 取走最后一枚石子的玩家失败.
]#theorem[
  先手必败当且仅当满足以下一种情况:
  1. 所有非空堆都只有 $1$ 枚石子, 且非空堆的数量为奇数;
  2. 至少有一堆石子数大于 $1$ , 且 $a_1 plus.o a_2 plus.o ... plus.o a_n=0$ .
]

==== Moore's Nim-k 游戏

#problem[
  有 $n$ 堆石子, 第 $i$ 堆有 $a_i$ 枚. 每次选择 $1$ 至 $k$ 个非空堆, 分别取走任意正数枚石子, 取走最后一枚者获胜.
]#theorem[
  记 $a_i^(d)$ 为 $a_i$ 的第 $d$ 个二进制位, 则先手必败当且仅当对任意 $d>=0$ 均有
  $ sum_(i=1)^n a_i^(d) equiv 0 (mod k+1) $ .
]

==== 阶梯 Nim 游戏

#problem[
  有 $n$ 堆石子, 第 $i$ 堆有 $a_i$ 枚. 每次从第 $1$ 堆取走任意正数枚石子, 或将第 $i(i>1)$ 堆的任意正数枚石子移至第 $i-1$ 堆, 取走最后一枚者获胜.
]#theorem[
  先手必败当且仅当奇数编号堆的石子数异或和为 $0$ , 即
  $ a_1 ⊕ a_3 ⊕ ... ⊕ a_(n-1+(n mod 2))=0 $ .
]

==== Fibonacci Nim 游戏

#problem[
  有一堆共 $n$ 枚石子. 第一次可取任意正数枚但不能取完; 此后每次至多取上一次取走数量的两倍, 取走最后一枚者获胜.
]#theorem[
  先手必败当且仅当 $n$ 是 Fibonacci 数.
]

==== Wythoff 游戏

#problem[
  有两堆石子, 数量分别为 $a_1,a_2$ . 每次可从一堆取走任意正数枚, 或从两堆各取走相同的正数枚, 取走最后一枚者获胜.
]#theorem[
  不妨设 $a_1<=a_2$ , 令 $phi=(sqrt(5)+1)/2$ , 则先手必败当且仅当
  $ a_1=lr(floor (a_2-a_1)phi floor.r) $ .
]

=== SG理论

#let mex=math.op("mex")
#let SG=math.op("SG")

==== 基本定义

#definition[公平组合游戏][
  两名玩家轮流操作, 同一状态下双方可选的操作完全相同, 且游戏必在有限步内结束. 以下只考虑正常规则, 即无法操作的玩家失败.
]
#definition[$mex$ 与 SG 函数][
  定义 $mex(S):=min {x in NN:x in.not S}$ , 即 $S$ 中没有出现的最小非负整数, 特别地 $mex(emptyset)=0$ .
  记状态 $x$ 的后继状态集合为 $F(x)$ , 则
  $ SG(x)=mex({SG(y):y in F(x)}) $ .
]
#theorem[胜负判定][
  $SG(x)=0$ 当且仅当 $x$ 为先手必败状态; $SG(x)!=0$ 当且仅当 $x$ 为先手必胜状态. 特别地, 终止状态的 SG 值为 $0$ .
]

==== SG 定理

#definition[游戏的和][
  若游戏由若干个互不影响的子游戏组成, 每次操作只选择其中一个子游戏行动, 则称整体为这些子游戏的和.
]
#theorem[Sprague--Grundy][
  任意有限的正常规则公平组合游戏都等价于一堆大小为其 SG 值的 Nim 游戏. 对于相互独立的子游戏 $G_1,G_2,...,G_n$ , 有
  $ SG(G_1+G_2+...+G_n)=SG(G_1) plus.o SG(G_2) plus.o ... plus.o SG(G_n) $ .
  因此所有子游戏 SG 值的异或和为 $0$ 时先手必败, 否则先手必胜.
]

==== 求解方法

1. 将游戏拆成相互独立的子游戏, 明确每个状态及其所有后继状态.
2. 用记忆化搜索或逆拓扑序, 从终止状态开始对后继状态的 SG 值取 $mex$ .
3. 将初始局面中各子游戏的 SG 值异或, 根据异或和是否为 $0$ 判断胜负.

#ps[
  若一次操作把一个游戏拆成若干个独立部分, 应先将这些部分的 SG 值异或, 再把所得结果放进当前状态的 $mex$ 集合. 反常规则、双方可选操作不同或游戏可能无限进行时, 不能直接套用 SG 定理.
]

== 数论

=== $mu$ -反演与Dirichlet卷积

==== $mu$ -反演
#h(2em) 对于一些数论函数我们直接计算他们是很困难的, 但是相对而言计算他们的约数项的和或者倍数项的和却很容易, 那么就可以借助整除序 $(NN,|)$ 上的 $mu$ (即莫比乌斯函数)来帮助我们反演.\ \ 
#theorem[$mu$ -反演, 约数和版本][
  $
  &g(n)=sum_(d|n)f(d),
  \
  &f(n)=sum_(d|n)mu(n/d)g(d)
  $
]
#theorem[$mu$ -反演, 倍数和版本][
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
  [`exgcd(x,y)` 对非负整数返回 `{g,u,v}`, 满足 $g=gcd(x,y)=u x+v y$ . ],
  [时间与递归栈空间均为 $O(log min(|x|,|y|))$ . ],
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
  [`norm(x,p)` 将 $x$ 归一化到 $[0,p)$ ; `BSGS(a,b,p,k)` 在 $gcd(a,p)=1$ 时求最小的 $x>=0$ 使 $k a^x equiv b mod p$ ; `exBSGS(a,b,p)` 去除互质限制; 无解返回 `-1`. 要求 $p>0$ , 且当前乘法实现要求参数均在 32 位整数范围内. ],
  [哈希表操作按期望 $O(1)$ 计, 时间与空间均为 $O(sqrt(p))$ . ],
)
#code-file("code/math/bsgs.cpp")

=== CRT & exCRT

#code-info(
  [`sym` 的每项 `{a,m}` 表示 $x equiv a mod m$ ; `CRT(sym)` 合并模数两两互质的同余式; `merge(x,y)` 合并两个一般同余式, 成功返回 $0$ 并修改 `x`; `exCRT(sym)` 处理非互质模数, 无解返回 `-1`. 模数须为正, 最终模数及所有乘法中间量须能由 `long long` 表示. ],
  [设同余式数为 $k$ 、最终模数为 $M$ : 时间 $O(k log M)$ ; 参数按值复制及递归栈共占 $O(k+log M)$ 空间. ],
)
#code-file("code/math/crt.cpp")

=== 线性筛素数&积性函数

#code-info(
  [`work(N,prime,low,f)` 筛出 $[2,N)$ 内的素数; `low[x]` 为 $x$ 中最小质因子的最高次幂. 要求 $N>=2$ , 并先在注释处补全质数幂的 `f[p^k]`. ],
  [时间 $O(N)$ , 输出及辅助空间 $O(N)$ . ],
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
  [`DuJiao_sieve(inv_g,S_g,S_fg)` 设置 $g(1)^(-1)$ 、$S_g(n)=sum_(i<=n)g(i)$ 与 $S_(f*g)(n)=sum_(i<=n)(f*g)(i)$ ; `solve(n,pre)` 根据 `pre[x]` 记忆化求 $sum_(i<=n)f(i)$ . 同一对象只能用于同一组函数和前缀和. ],
  [预处理界取 $B=Theta(n^(2/3))$ 时, 期望时间与总空间均为 $O(n^(2/3))$ ; 回调值、前缀和及 $g(1)^(-1)$ 均须先取模. ],
)
#code-file("code/math/Du'sSieve.cpp")

==== 常见的构造列表

=== Min_25筛

=== 万能欧几里德方法

==== 问题
设 $(T,D,e)$ 为幺半群, 即 $D:T times T arrow T$ 满足结合律, $e$ 为双侧单位元. 给定 $u,r in T$ 以及整数 $n,a,b>=0$、$c>0$ , 记
$
  y_i=lr(floor (a i+b)/c floor.r) quad (0<=i<=n).
$
约定 $x^0=e$、$x^k=D(x^(k-1),x)$ , 万能欧几里得方法所求的是
$
  F(n,a,b,c;u,r)=u^(y_0) product_(i=1)^n (r u^(y_i-y_(i-1))).
$
式中的乘法均指运算 $D$ , 且乘积严格按照 $i$ 递增的顺序计算. 它等价于对直线 $y=lr(floor (a x+b)/c floor.r)$ 下方的格路径编码: 每向上一步乘入 $u$ , 每向右一步乘入 $r$ . 因为 $D$ 不要求满足交换律, 操作的先后顺序不能改变.

==== 实现
#code-info(
  [`MegaEuclid(unit,D)` 固定幺半群的单位元与结合运算; 令 $y_i=lr(floor (a i+b)/c floor.r)$ , `solve(n,a,b,c,u,r)` 返回操作串 $u^(y_0) product_(i=1)^n (r u^(y_i-y_(i-1)))$ 的幺半群积, 其中 `u`、`r` 分别表示向上、向右一步. 第 $i+1$ 个 `r` 出现于 $(i,y_i)$ , 故它编码的取整值下标范围为 $0<=i<n$ ; 若要求 $0<=i<=N$ , 应传入 `n=N+1`. ],
  [`D` 必须满足结合律, `unit` 必须是其双侧单位元; 要求 $n,a,b>=0$ 、$c>0$ , 且中间商能存入 `int`. 令 $M=max(n,a,b,c,2)$ , 在一次 `D` 运算与一次 `T` 拷贝均为 $O(1)$ 时, 递归深度为 $O(log M)$ , 每个连续操作块的幂由 `qpow` 在 $O(log M)$ 次 `D` 运算内求出, 因而总时间为 $O(log^2 M)$ , 递归栈空间为 $O(log M)$ . ],
)
#code-file("code/math/UniversalEuclid.cpp")

== 多项式

=== 复数FFT

#code-info(
  [`cmplx` 提供复数四则所需操作; `fft(f,tag)` 原地执行长度为二次幂的 DFT(`tag=0`)或 IDFT(`tag=1`). ],
  [长度为 $n$ 时, 时间 $O(n log n)$ , 除输入数组外额外空间 $O(1)$ . ],
)
#code-file("code/math/fft.cpp")

=== 取模全家桶
#code-info(
  [`poly` 提供长度调整、下标访问、NTT/INTT、加减乘、求逆与求导; `integral()` 预留为积分接口, 但当前实现尚未完成. ],
  [加减与求导为 $O(n)$ ; 变换、乘法及求逆为 $O(n log n)$ ; 工作空间 $O(n)$ . 当前文件因 `integral()` 未完成而不能编译. ],
)
#code-file("code/math/poly(mod).cpp")
