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

=== 常见组合恒等式

未注明时, $n,m,r,s,t,b$ 均为非负整数. 对 $n>=0$, 约定 $k<0$ 或 $k>n$ 时 $binom(n,k)=0$, 空和为 $0$, $0^0=1$.
下降幂、第二类斯特林数和指示函数 $I(P)$ 沿用前文定义.

#let comb-id(title, body) = block(
  width: 100%, breakable: false, above: 0pt, below: 0pt,
)[#property(title, body)]

#comb-id[基本关系][
  $
  &binom(n,k)=binom(n,n-k), \
  &binom(n,k)=binom(n-1,k)+binom(n-1,k-1) quad (n>=1).
  $
]

#comb-id[吸收与拆分][
  前两式要求 $n>=1$; 第三式要求 $0<=r<=k<=n$.
  $
  &k binom(n,k)=n binom(n-1,k-1), \
  &(n-k)binom(n,k)=n binom(n-1,k), \
  &binom(n,k)binom(k,r)=binom(n,r)binom(n-r,k-r).
  $
  常用于提取权重、先选子集再选其中的标记元素.
]

#comb-id[二项式行和][
  $
  &sum_(k=0)^n binom(n,k)=2^n, \
  &sum_(k=0)^n (-1)^k binom(n,k)=I(n=0), \
  &sum_(0<=k<=n, 2 divides k) binom(n,k)
    =sum_(0<=k<=n, 2 divides.not k) binom(n,k)=2^(n-1) quad (n>=1).
  $
]

#comb-id[曲棍球棒与对角卷积][
  $
  &sum_(k=r)^n binom(k,r)=binom(n+1,r+1) quad (n>=r), \
  &sum_(k=0)^n binom(k,r)binom(n-k,s)=binom(n+1,r+s+1).
  $
]

#comb-id[范德蒙德卷积][
  $
  &sum_(k=0)^r binom(n,k)binom(m,r-k)=binom(n+m,r), \
  &sum_(k=0)^(min(n,m)) binom(n,k)binom(m,k)=binom(n+m,n), \
  &sum_(k=0)^n binom(n,k)^2=binom(2n,n).
  $
  将两组元素合并后选取, 常用于消去一层组合数求和.
]

#comb-id[带标记组合数求和][
  要求 $0<=r<=n$.
  $
  &sum_(k=r)^n binom(n,k)binom(k,r)=binom(n,r)2^(n-r), \
  &sum_(k=r)^n (-1)^(k-r)binom(n,k)binom(k,r)=I(n=r).
  $
]

#comb-id[交错求和][
  $
  &sum_(k=0)^m (-1)^k binom(n,k)=(-1)^m binom(n-1,m) quad (n>=1), \
  &sum_(k=0)^n (-1)^k binom(n,k)binom(m+k,r)=(-1)^n binom(m,r-n).
  $
]

#comb-id[加权二项式和][
  $
  &sum_(k=0)^n k binom(n,k)=n 2^(n-1) quad (n>=1), \
  &sum_(k=0)^n k^2 binom(n,k)=n(n+1)2^(n-2) quad (n>=2), \
  &sum_(k=t)^n k^underline(t)binom(n,k)x^(k-t) \
  &quad =n^underline(t)(1+x)^(n-t) quad (0<=t<=n).
  $
  对二项式定理求导可得到下降幂权重; 再转为普通幂.
]

#comb-id[幂次和与高阶差分][
  $
  &sum_(k=0)^n binom(n,k)k^r \
  &quad =sum_(j=0)^(min(n,r)) stl2(r,j)n^underline(j)2^(n-j), \
  &sum_(k=0)^n (-1)^(n-k)binom(n,k)k^r=n!stl2(r,n).
  $
  第二式在 $r<n$ 时为 $0$, 在 $r=n$ 时为 $n!$.
  更一般地, 若多项式 $P$ 的次数小于 $n$, 则
  $ sum_(k=0)^n (-1)^(n-k)binom(n,k)P(k)=0. $
]

#comb-id[倒数加权和][
  $
  &sum_(k=0)^n binom(n,k)/(k+1)=(2^(n+1)-1)/(n+1), \
  &sum_(k=0)^n (-1)^k binom(n,k)/(k+1)=1/(n+1).
  $
]

#comb-id[生成函数与组合卷积][
  第一式按形式幂级数理解, 要求 $m>=1$; 第二式中 $a,b$ 为任意数列.
  $
  &(1-x)^(-m)=sum_(k>=0)binom(m+k-1,k)x^k, \
  &sum_(k=0)^n binom(n,k)a_k b_(n-k) \
  &quad =n!sum_(k=0)^n (a_k)/(k!) (b_(n-k))/((n-k)!).
  $
  将数列除以阶乘后做普通卷积, 再乘回阶乘, 即得二项式卷积.
]

#comb-id[有上界的隔板计数][
  对 $n>=1$, $x_1+...+x_n=m$ 且 $0<=x_i<=b$ 的整数解数为
  $
  N=sum_(j=0)^(min(n, floor(m/(b+1))))
    (-1)^j binom(n,j)binom(m-j(b+1)+n-1,n-1).
  $
  有下界时先平移变量, 再对违反上界的变量容斥.
]

#v(3pt)
含除法的等式用于取模时, 只有分母与模数互质才可直接使用逆元; 整数商也可先约分后计算.

#text(size: 6pt)[
  参考: #link("https://dlmf.nist.gov/1.2")[DLMF §1.2],
  #link("https://dlmf.nist.gov/26.3")[§26.3],
  #link("https://dlmf.nist.gov/26.8")[§26.8],
  #link("https://cp-algorithms.com/combinatorics/binomial-coefficients.html")[CP-Algorithms: Binomial Coefficients],
  #link("https://cp-algorithms.com/combinatorics/inclusion-exclusion.html")[Inclusion-Exclusion].
]

=== Lucas 定理

#h(2em) 对于质数 $p$ 而言, 我们可以快速求出组合数对 $p$ 取余数的结果.
#theorem[Lucas][
  对于 $n,m in NN$ 有 $ binom(n,m) equiv binom(n mod p, m mod p)dot binom(lr(floor n/p floor.r),lr(floor m/p floor.r)) (mod p) $
]

=== 生成函数

==== 定义与约定

以下将 $x$ 视为形式符号, 按特征零的域上的形式幂级数运算, 不要求数值收敛.
求 $0..N$ 次项时模 $x^(N+1)$ 截断. 模意义下可取奇质数 $p$ 且 $N<p$, 保证下述阶乘及整数分母可逆;
此条件须覆盖运算所需的最高次数.

#table(
  columns: (0.6fr, 1.9fr, 1.1fr),
  stroke: 0.35pt + luma(150), inset: 2pt, align: center,
  table.header([*类型*], [*定义*], [*取答案*]),
  [OGF], [$F(x)=sum_(n>=0)a_n x^n$], [$a_n=[x^n]F$],
  [EGF], [$A(x)=sum_(n>=0)a_n x^n/n!$], [$a_n=n![x^n]A$],
)
#v(2pt)

结合卷积系数选择表示方式: 普通卷积用 OGF; 带标号分配系数 $binom(n,k)$ 的卷积常用 EGF.
所有系数下标从 $0$ 开始, 负下标项为 $0$.

#property[运算条件与精度][
  求逆要求 $F(0)!=0$; 形式 $ln F$ 要求 $F(0)=1$; $exp A$ 要求 $A(0)=0$.
  一般的复合 $F(G(x))$ 要求 $G(0)=0$, 外层 $F$ 为多项式时不受此限制.
  要得到导数的 $0..N$ 次项, 原级数须已知到 $N+1$ 次.
]

==== 基本运算速查

下表固定 $F(x)=sum_(n>=0)a_n x^n$ 为 *OGF*, $s>=0,d>=1$.

#table(
  columns: (1.25fr, 1.55fr),
  stroke: 0.35pt + luma(150), inset: 2pt, align: center,
  table.header([*生成函数*], [*对应序列的第 $n$ 项*]),
  [$x^s F(x)$], [$a_(n-s)$],
  [$(F(x)-sum_(j=0)^(s-1)a_j x^j)/x^s$], [$a_(n+s)$],
  [$F(c x)$], [$c^n a_n$],
  [$F(x^d)$], [第 $d n$ 项为 $a_n$, 其余为 $0$],
  [$F(x)/(1-x)$], [$sum_(j=0)^n a_j$],
  [$(1-x)F(x)$], [$a_n-a_(n-1)$],
  [$F'(x)$], [$(n+1)a_(n+1)$],
  [$x F'(x)$], [$n a_n$],
  [$integral_0^x F(t) dif t$], [$a_(n-1)/n$ ($n>=1$), 常数项 $0$],
)
#v(2pt)

#property[卷积、EGF 移位与奇偶筛选][
  令 $G=sum b_n x^n$, $A=sum a_n x^n/n!$, $B=sum b_n x^n/n!$, 则
  $
  &[x^n](F G)=sum_(k=0)^n a_k b_(n-k), \
  &n![x^n](A B)=sum_(k=0)^n binom(n,k)a_k b_(n-k), \
  &A'(x)=sum_(n>=0)a_(n+1)x^n/n!, \
  &integral_0^x A(t) dif t=sum_(n>=1)a_(n-1)x^n/n!.
  $
  EGF 乘 $x^s$ 对应 $n^underline(s)a_(n-s)$ ($n>=s$), 更低项为 $0$.
  对 OGF、EGF 均可用 $(F(x)+F(-x))/2$ 保留偶次项,
  $(F(x)-F(-x))/2$ 保留奇次项; 次数保持原样.
]

==== 常用展开与封闭形式

表内 $n>=0$, 有常数项的例外单独注明. $(1+x)^alpha$ 的常数项取 $1$.

#table(
  columns: (1.15fr, 1.15fr, 0.7fr),
  stroke: 0.35pt + luma(150), inset: 2pt, align: center,
  table.header([*函数 $F(x)$*], [*$[x^n]F(x)$*], [*条件*]),
  [$1/(1-c x)$], [$c^n$], [无],
  [$1/(1-x)^m$], [$binom(m+n-1,n)$], [$m>=1$ 为整数],
  [$x/(1-x)^2$], [$n$], [无],
  [$x(1+x)/(1-x)^3$], [$n^2$], [无],
  [$(1+x)^alpha$], [$alpha^underline(n)/n!$], [广义二项式],
  [$exp(c x)$], [$c^n/n!$], [无],
  [$-ln(1-x)$], [$1/n$], [$n>=1$; 常数 $0$],
  [$ln(1+x)$], [$(-1)^(n-1)/n$], [$n>=1$; 常数 $0$],
)
#v(2pt)

这里的广义组合数定义为 $binom(alpha,n)=alpha^underline(n)/n!$, 允许负上标.
特别地, 对整数 $m>=1$ 有
$ binom(-m,n)=(-1)^n binom(m+n-1,n). $
前文非负整数上标的越界置零约定不适用于负上标.
模质数 $p$ 时, 组合数上标 $>=p$ 不能直接套含有 $p!$ 的阶乘逆元公式, 可参考 Lucas 定理.

==== OGF 计数模型

对重量为 $w>=1$ 的一种物品, 其数量限制对应以下因子.
要求 $0<=L<=U$, $m>=1$, $0<=r<m$, 所有这些参数均为整数.

#table(
  columns: (1fr, 1.6fr),
  stroke: 0.35pt + luma(150), inset: 2pt, align: center,
  table.header([*允许的取用数量*], [*生成函数因子*]),
  [$0$ 或 $1$], [$1+x^w$],
  [任意非负整数], [$1/(1-x^w)$],
  [恰好 $L$ 个], [$x^(L w)$],
  [$L..U$ 个], [$x^(L w)(1-x^((U-L+1)w))/(1-x^w)$],
  [数量 $equiv r (mod m)$], [$x^(r w)/(1-x^(m w))$],
)
#v(2pt)

各类型独立选择时相乘, 总重量为 $S$ 的方案数是 $[x^S]product_i F_i(x)$.
例如无限硬币取 $product_i (1-x^(w_i))^(-1)$, 每种至多一枚取 $product_i (1+x^(w_i))$.

#property[有序序列][
  若非空部件的 OGF 是 $F$, 即 $F(0)=0$, 则
  $
  &"恰好 " k " 个有序部件": quad F^k, \
  &"任意个有序部件": quad sum_(k>=0)F^k=1/(1-F), \
  &"至少一个有序部件": quad F/(1-F).
  $
  序列记录部件的先后顺序; 独立选择每种物品的乘积模型记录各类型的数量.
]

==== EGF 计数模型

以下原子均带标号, 各部件使用互不相交的标号集合.
设一种 *非空* 部件的 EGF 为 $A$, 满足 $A(0)=0$.
表内 $k$ 为非负整数, 环模型要求 $k>=1$.

#table(
  columns: (1.6fr, 1fr),
  stroke: 0.35pt + luma(150), inset: 2pt, align: center,
  table.header([*组合结构*], [*EGF*]),
  [恰好 $k$ 个有序部件], [$A^k$],
  [恰好 $k$ 个无序部件], [$A^k/k!$],
  [任意个无序部件], [$exp A$],
  [任意个有序部件], [$1/(1-A)$],
  [恰好 $k$ 个部件组成一个环], [$A^k/k$],
  [任意正数个部件组成一个环], [$-ln(1-A)$],
  [在结构中标记一个原子], [$x A'(x)$],
)
#v(2pt)

环仅将旋转视为相同, 翻转仍不同. 无序部件的 $k!$ 来自标号集合分配后的去重,
不能直接套给一般无标号 OGF. 从表中表达式取出 $x^n$ 系数后, 均须乘回 $n!$.
固定 $k$ 个非空部件时, 若 $n<k$ 则直接返回 $0$; 其余情况才需计算 $k!$ 或 $k$ 的逆元.
若还要记录无序部件数, 使用 $exp(y A(x))$, 答案为 $n![x^n y^k]exp(y A(x))$.

#property[集合划分、置换与连通图][
  集合划分的部件是非空集合, 故取 $A=exp x-1$:
  $
  &stl2(n,k)=n![x^n](exp x-1)^k/k!, \
  &sum_(k=0)^n stl2(n,k)=n![x^n]exp(exp x-1).
  $
  置换是置换环的无序集合, 环的 EGF 为 $-ln(1-x)$.
  禁止长度 $1$ 的环即得错排数的 EGF $exp(-x)/(1-x)$.
  对带标号简单无向图, 令
  $
  G(x)=sum_(n>=0)2^binom(n,2)x^n/n!,
  $
  则非空连通图的 EGF 为 $ln G(x)$, 一般图由连通分量作无序集合得到.
]

==== 递推与生成函数方程

#property[常系数线性递推][
  已知 $a_0,..,a_(d-1)$, 且 $a_n=sum_(i=1)^d c_i a_(n-i)$ ($n>=d$, $d>=1$), 则 OGF 满足
  $
  &Q(x)=1-sum_(i=1)^d c_i x^i, \
  &P(x)=sum_(j=0)^(d-1)(a_j-sum_(i=1)^j c_i a_(j-i))x^j, \
  &F(x)=P(x)/Q(x).
  $
  分子由初值决定. 例如 $a_0=0,a_1=1,a_n=a_(n-1)+a_(n-2)$ 时 $F=x/(1-x-x^2)$.
]

#property[卷积递推与递归结构][
  若 $f_n=b_n+sum_(i=1)^n g_i f_(n-i)$, 取 OGF $F,B,G$ 且 $g_0=0$, 则
  $ F=B+G F quad => quad F=B/(1-G). $
  自卷积产生非线性方程, 例如卡特兰数的 OGF:
  $
  &C=1+x C^2, quad C(0)=1, \
  &C=(1-sqrt(1-4x))/(2x).
  $
  平方根取常数项为 $1$ 的分支. 带标号有根树由根和若干无序子树构成, 其 EGF 满足
  $ T=x exp T, quad T(0)=0. $
  由下述反演可得 $n>=1$ 时树数为 $n^(n-1)$.
]

#note-box[
  *与多项式代码衔接:* 求 $0..N$ 次项的形式商 $B/A$, 先将分母补零到 $N+1$ 项,
  用 #raw("A.inverse()") 后乘以 #raw("B"), 再截断; 当前 #raw("poly") 的 #raw("/") 是多项式带余除法.
  #raw("power")、#raw("sqrt") 的基础版本要求常数项为 $1$.
  $F=B+x^k F^2$ ($k>=1$) 可直接使用“在线卷积”片段.
]

==== Lagrange 反演

#theorem[隐式方程取系数][
  设 $T=x phi(T)$, $phi(0)!=0$, 则存在唯一满足 $T(0)=0$ 的形式解.
  对任意形式幂级数 $H$ 及整数 $n>=1$,
  $
  [x^n]H(T(x))=1/n [t^(n-1)]H'(t)phi(t)^n.
  $
  特别地, 对 $n>=k>=1$ 有
  $
  [x^n]T(x)^k=k/n [t^(n-k)]phi(t)^n.
  $
  $n=0$ 时直接取 $H(0)$; $k>n$ 时 $[x^n]T^k=0$.
]

#example[代入二项式][
  若 $T=x(1+T)^m$, $m>=1$ 为整数, 则对 $n>=k>=1$,
  $ [x^n]T^k=k/n binom(m n,n-k). $
  将隐式递推转成一次幂及取系数, 不必先求出整个 $T$.
]

#v(2pt)
#text(size: 6pt)[
  参考: OI Wiki
  #link("https://oi-wiki.org/math/poly/intro/")[简介],
  #link("https://oi-wiki.org/math/poly/ogf/")[OGF],
  #link("https://oi-wiki.org/math/poly/egf/")[EGF],
  #link("https://oi-wiki.org/math/poly/lagrange-inversion/")[Lagrange 反演].
  辅助阅读: #link("https://www.cnblogs.com/bykem/p/20097078")[Phartial 多项式笔记],
  #link("https://q779.cn/2024/01/31/sheng-cheng-han-shu-xue-xi-bi-ji/")[Q779 生成函数笔记].
]

== 博弈论

#let mex=math.op("mex")
#let SG=math.op("SG")

=== 常见模型

==== Nim游戏

#problem[
共有 $n$ 堆石子, 第 $i$ 堆有 $a_i$ 枚石子. 两名玩家轮流取走任意一堆中的任意多枚石子, 但是不能不取. 取走最后一枚石子的玩家获胜
]#theorem[SG值][
  单堆大小为 $x$ 时,
  $ SG(x)=mex({SG(y):0<=y<x})=x. $
  多堆相互独立, 因而
  $ SG(a_1,...,a_n)=a_1 plus.o a_2 plus.o ... plus.o a_n. $
  先手必败当且仅当此值为 $0$ ; 计算时间 $O(n)$ .
]

==== Bachet游戏

#problem[
  有一堆共 $n$ 枚石子, 每次取走 $1$ 至 $k$ 枚, 取走最后一枚者获胜.
]#theorem[SG值][
  $ SG(n)=mex({SG(n-t):1<=t<=min(n,k)})=n mod (k+1). $
  先手必败当且仅当 $n equiv 0 (mod k+1)$ .
  单次计算 $O(1)$ ; 若有若干独立堆, 第 $i$ 堆的取数上限为 $k_i$ , 则整体 SG 值为各个 $a_i mod (k_i+1)$ 的异或和.
]

==== 反常Nim游戏

#block(breakable: false, above: 0pt, below: 0pt)[
  #problem[
    共有 $n$ 堆石子, 两名玩家轮流从任意一个非空堆中取走任意正数枚石子. 与普通 Nim 不同, 取走最后一枚石子的玩家失败.
  ]#theorem[
    先手必败当且仅当满足以下一种情况:
    1. 所有非空堆都只有 $1$ 枚石子, 且非空堆的数量为奇数;
    2. 至少有一堆石子数大于 $1$ , 且 $a_1 plus.o a_2 plus.o ... plus.o a_n=0$ .
  ]
]
#ps[
  *SG适用范围:* 本模型采用反常规则, 不能套用通常的 SG 异或定理. 若仍按 $mex(emptyset)=0$ 对同一转移图求值, 得到的是相应普通 Nim 的 SG 值, 即所有堆的异或和, 不代表这里的胜负. 例如单堆 $1$ 的普通 SG 值为 $1$ , 但反常规则下先手必败.
]

==== Moore's Nim-k 游戏

#problem[
  有 $n$ 堆石子, 第 $i$ 堆有 $a_i$ 枚, $1<=k<=n$ . 每次选择 $1$ 至 $k$ 个非空堆, 分别取走任意正数枚石子, 取走最后一枚者获胜.
]#theorem[
  记 $a_i^(d)$ 为 $a_i$ 的第 $d$ 个二进制位, 则先手必败当且仅当对任意 $d>=0$ 均有
  $ sum_(i=1)^n a_i^(d) equiv 0 (mod k+1). $
]
// Moore 值与 SG 的区别: Boros et al., arXiv:1508.04484, §1 / Theorem 3.
#property[SG值][
  状态为整个堆大小向量 $bold(a)$ . 后继向量 $bold(b)$ 满足每一维 $0<=b_i<=a_i$ , 且严格减小的坐标数在 $1$ 至 $k$ 之间. 记这些后继组成的集合为 $F_(k)(bold(a))$ , 则
  $ SG_(k)(bold(a))=mex({SG_(k)(bold(b)):bold(b) in F_(k)(bold(a))}), $
  初值为 $SG_(k)(0,...,0)=0$ . 小规模时可枚举合法后继并记忆化搜索, 或按总石子数递增 DP; 状态数至多为 $product_(i=1)^n (a_i+1)$ , 可将堆大小排序后作为缓存键.

  特例: $k=1$ 时为普通 Nim; 若非空堆数不超过 $k$ , 则 $SG_(k)(bold(a))=sum_i a_i$ .
]
#ps[
  记 $c_d=(sum_i a_i^(d)) mod (k+1)$ , 将余数按 $k+1$ 进制拼成 Moore 值
  $ M(bold(a))=sum_(d>=0) c_d dot (k+1)^d. $
  对 $v in {0,1}$ 有 $SG_(k)(bold(a))=v$ 当且仅当 $M(bold(a))=v$ , 但一般不能将 $M$ 当作完整 SG 值. 例如 $k=2$ 时, $M(2,3,3)=2$ 而 $SG_(2)(2,3,3)=8$ . 一次可修改多堆, 因此也不能逐堆求 SG 后直接异或.
]

==== 阶梯 Nim 游戏

#problem[
  有 $n$ 堆石子, 第 $i$ 堆有 $a_i$ 枚. 每次从第 $1$ 堆取走任意正数枚石子, 或将第 $i(i>1)$ 堆的任意正数枚石子移至第 $i-1$ 堆, 取走最后一枚者获胜.
]#theorem[SG值][
  完整 SG 值为奇数编号堆的石子数异或和:
  $ SG(a_1,...,a_n)=a_1 plus.o a_3 plus.o ... plus.o a_(n-1+(n mod 2)). $
  先手必败当且仅当此值为 $0$ ; 计算时间 $O(n)$ .
  任一步恰改变一个奇数编号堆, 因而异或值必改变; 对当前值 $s$ 的每个 $0<=t<s$ , 都可像普通 Nim 一样减小某个奇数堆使异或值变为 $t$ , 所以后继值的 $mex$ 恰为 $s$ .
]

==== Fibonacci Nim 游戏

#problem[
  有一堆共 $n>=1$ 枚石子. 第一次可取任意正数枚但不能取完; 此后每次至多取上一次取走数量的两倍, 取走最后一枚者获胜.
]#theorem[
  先手必败当且仅当 $n$ 是 Fibonacci 数.
]
// 状态与零值判定: Larsson & Rubinstein-Salzedo, arXiv:1410.0332, §1 / Theorem 4.1.
#property[SG值][
  必须将本轮可取上限 $r$ 纳入状态, 只记录剩余石子数 $n$ 不够. 初始局面的值为 $SG(n,n-1)$ . 将上限截为 $r<=n$ 后,
  $
    &SG(0,r)=SG(n,0)=0,\
    &SG(n,r)=mex({SG(n-t,min(2t,n-t)):1<=t<=r}).
  $
  预处理 $n<=N$ 时, 按 $n$ 递增, 对固定 $n$ 令 $r$ 从 $1$ 增至 $n$ . 每次只新增一个后继值 $SG(n-r,min(2r,n-r))$ 到标记集合, 再向上维护 $mex$ . 这样总时间与空间均为 $O(N^2)$ ; 上限大于剩余石子数时查询 $SG(n,n)$ .

  仅判零值时, 将 $n>0$ 贪心拆成互不相邻的 Fibonacci 数之和 (数列取 $1,2,3,5,...$ ), 记最小项为 $z(n)$ , 则 $SG(n,r)=0$ 当且仅当 $r<z(n)$ . $z(n)$ 不是一般 SG 值, 例如 $z(4)=1$ 而 $SG(4,3)=3$ .
]
#ps[
  多堆 Fibonacci Nim 只有在每堆独立维护自己的取数上限时, 才能将各堆的 $SG(n,r)$ 异或. 若一次操作改变其他堆的上限, 则需重新定义整个游戏的状态.
]

==== Wythoff 游戏

#block(breakable: false, above: 0pt, below: 0pt)[
  #problem[
    有两堆石子, 数量分别为 $a_1,a_2$ . 每次可从一堆取走任意正数枚, 或从两堆各取走相同的正数枚, 取走最后一枚者获胜.
  ]#theorem[
    不妨设 $a_1<=a_2$ , 令 $phi=(sqrt(5)+1)/2$ , 则先手必败当且仅当
    $ a_1=lr(floor (a_2-a_1)phi floor.r). $
  ]
]
// 完整递推: Nivasch, More on the Sprague--Grundy function for Wythoff's game, (1-3).
#property[SG值][
  记两堆大小为 $a,b$ , 枚举单堆减少与两堆等量减少的后继:
  $
    &SG(a,b)=mex(S_1 union S_2 union S_3),\
    &S_1={SG(x,b):0<=x<a},\
    &S_2={SG(a,y):0<=y<b},\
    &S_3={SG(a-t,b-t):1<=t<=min(a,b)}.
  $
  边界为 $SG(a,0)=a$ 、$SG(0,b)=b$ , 且 $SG(a,b)=SG(b,a)$ . 预处理 $0<=a,b<=N$ 时, 按 $a$ 递增, 再按 $b$ 递增, 对后继值取 $mex$ ; 朴素时间 $O(N^3)$ , 空间 $O(N^2)$ .

  黄金分割公式只刻画 $SG=0$ 的状态. 两堆不是独立子游戏, 不能直接异或堆大小; 例如 $SG(1,1)=2$ 而 $1 plus.o 1=0$ .
]

=== SG理论

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
  设 $R$ 为含幺交换环. 对于数论函数 $f,g:NN^+->R$ , 定义它们的Dirichlet卷积
  $
  f*g:&NN^+->R\ &n mapsto sum_(d|n)f(d)dot g(n/d)
  $
]\ 
#definition[积性函数][
  称一个数论函数 $f:NN^+->R$ 是积性函数, 当且仅当 $f(1)=1_R$ , 且对于 $n,m in NN^+$ , 若 $gcd(n,m)=1$ 则 $f(n)dot f(m)=f(n dot m)$ 成立.
]\
#definition[完全积性函数][
  称一个数论函数 $f:NN^+->R$ 是完全积性函数, 当且仅当 $f(1)=1_R$ , 且对于任意的 $n,m in NN^+$ , 均有 $f(n)dot f(m)=f(n dot m)$ 成立.
]\
#h(2em) 根据积性函数的定义, 我们可以把每个积性函数一一对应为一组素数幂上的取值. 这本质的原因是每个数的素因子分解是唯一的, 对于积性函数 $f$ 以及正整数 $n$ 而言, 假定 $n$ 的质因子分解为$ n=p_1^(a_1)times p_2^(a_2)times ...times p_k^(a_k) $ 那么可以直接得到 $ f(n)=f(p_1^(a_1))times f(p_2^(a_2))times ... times f(p_k^(a_k)) $ 因此我们只需要为每个 $p in PP$ 以及 $a in NN^+$ 指派 $f(p^a)$ 的值即可.

#h(2em) 对于完全积性函数 $g$ , 我们只需要指派 $g(p)$ 的值即可, 因为 $g(p^n)=g(p)^n$ .\ \ 

#theorem[
  设 $cal(M)_R$ 是全体取值于含幺交换环 $R$ 的积性函数的集合, $*$ 是Dirichlet卷积, 那么 $(cal(M)_R,*)$ 构成一个交换群(这意味着所有积性函数都有唯一的Dirichlet卷积逆).\ 
  #h(2em) 不过朴素的乘法 $dot$ 不对 $*$ 满足分配律, 所以 $(cal(M)_R,dot,*)$ 不构成环.
]

==== 常见的积性函数与卷积

#table(
  columns: (0.7fr, 1.25fr, 0.7fr, 1.35fr),
  stroke: 0.35pt + luma(150),
  inset: 2pt,
  [函数 $f$], [$f(p^a)$ ($a>=1$ )], [常用函数 $g$], [Dirichlet卷积 $f*g$],
  [$epsilon$], [$0$], [任意 $h$], [$epsilon*h=h$],
  [$bold(1)$], [$1$], [$id^k$], [$bold(1)*id^k=sigma_k$],
  [$id^k$], [$p^(a k)$], [$mu$], [$id^k*mu=J_k$],
  [$mu$], [$a=1$ 时为 $-1$ , 否则为 $0$], [$bold(1)$], [$mu*bold(1)=epsilon$],
  [$phi$], [$p^(a-1)(p-1)$], [$bold(1)$], [$phi*bold(1)=id$],
  [$J_k$], [$p^(a k)-p^((a-1)k)$], [$bold(1)$], [$J_k*bold(1)=id^k$],
  [$tau$], [$a+1$], [$mu$], [$tau*mu=bold(1)$],
  [$sigma_k$], [$sum_(i=0)^a p^(i k)$], [$mu$], [$sigma_k*mu=id^k$],
  [$lambda$], [$(-1)^a$], [$bold(1)$], [$lambda*bold(1)=q_2$],
  [$Q_r$], [$[a<r]$], [$q_r$], [$Q_r*q_r=bold(1)$],
)

#h(2em) 表中 $p$ 为素数, $k>=1$ , $r>=2$ . 记 $epsilon(n)=[n=1]$ , $bold(1)(n)=1$ , $id^k(n)=n^k$ , $tau=sigma_0$ , $J_k=id^k*mu$ ; $lambda$ 是 Liouville 函数. 另外, $q_r(n)=[exists m in NN^+,n=m^r]$ 是完全 $r$ 次幂指示函数, $Q_r(n)$ 是无 $r$ 次方因子数的指示函数, 特别地 $Q_2=mu^2$ .

#h(2em) 对于 $s>=t>=0$ , 还有
$
  (id^s*id^t)(n)=id^t(n)sigma_(s-t)(n),
$
特别地 $id^s*id^s=id^s tau$ . 更一般地, 若 $w$ 完全积性, 则 $(w f)*(w g)=w(f*g)$ , 这里 $w f$ 表示逐点乘积.

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

#table(
  columns: (1fr, 1fr, 1fr),
  stroke: 0.35pt + luma(150),
  inset: 2pt,
  [要求前缀和的函数 $f$], [构造的函数 $g$], [$f*g$],
  [#link("https://www.luogu.com.cn/problem/P4213")[P4213]: $mu$], [$bold(1)$], [$mu*bold(1)=epsilon$],
  [#link("https://www.luogu.com.cn/problem/P4213")[P4213]: $phi$], [$bold(1)$], [$phi*bold(1)=id$],
  [$id^k mu$], [$id^k$], [$(id^k mu)*id^k=epsilon$],
  [#link("https://www.luogu.com.cn/problem/P3768")[P3768 ($k=2$ )]: $id^k phi$], [$id^k$], [$(id^k phi)*id^k=id^(k+1)$],
  [$J_k$], [$bold(1)$], [$J_k*bold(1)=id^k$],
  [$lambda$], [$bold(1)$], [$lambda*bold(1)=q_2$],
  [#link("https://www.luogu.com.cn/problem/P4318")[P4318 ($r=2$ )]: $Q_r$], [$q_r$], [$Q_r*q_r=bold(1)$],
)

#h(2em) 其中 $bold(1)(n)=1$ , $epsilon(n)=[n=1]$ , $id^k(n)=n^k$ ; $id^k f$ 表示逐点乘积 $n^k f(n)$ . $J_k=id^k*mu$ 为 Jordan 函数, $lambda$ 为 Liouville 函数. 对 $r>=2$ , 记 $q_r(n)=[exists m in NN^+,n=m^r]$ , $Q_r(n)$ 为无 $r$ 次方因子数的指示函数, 则 $S_(q_r)(n)=lr(floor n^(1/r) floor.r)$ . P4318 对应 $Q_2=mu^2$ . 对固定的 $k$ , $S_(id^k)$ 可由幂和公式计算, 因而上表中 $g$ 与 $f*g$ 的前缀和都可快速求出.

#h(2em) $sigma_k*mu=id^k$ 与 $tau*mu=bold(1)$ 也成立, 但它们要求预先能够计算 $S_mu$ , 因此属于链式构造, 不属于上表中可直接调用杜教筛的构造.

=== Min_25筛

#h(2em) 设 $f$ 为满足 $f(1)=1$ 的积性函数, 且在质数处有 $f(p)=sum_(k=0)^d c_k p^k$ . Min_25 筛利用整数幂和筛出各个 $sum_(p<=x)p^k$ , 再按照最小质因子递归枚举质数幂, 从而求出 $sum_(i=1)^n f(i)$ .\ \ 

#text(size: 6.2pt)[
  *构造:* `Min25_sieve(sym,S_pow,f_pk)` \
  #table(
    columns: (1.05fr, 3.25fr),
    stroke: 0.35pt + luma(150),
    inset: 1.8pt,
    [*参数*], [*必须传入的内容*],
    [`sym`], [`VI` 类型的系数表. 若 $f(p)=sum_(k=0)^d c_k p^k$ 对每个质数 $p$ 成立, 则令 `sym[k]=c_k`, 长度为 $d+1$ . 系数先对 `mo` 取模, 例如 $-1$ 输入 `mo-1`. ],
    [`S_pow`], [可调用对象. `S_pow(k,x)` 中 `k` 是幂次, `x` 是未取模的求和上界; 返回 $sum_(t=1)^x t^k mod "mo"$ . 必须实现所有 $0<=k<"sym.size()"$ 的情况, 即使 `sym[k]=0`. ],
    [`f_pk`], [可调用对象. `f_pk(p,e,pe)` 中 `p` 是质数, `e>=1` 是指数, `pe` 是未取模的整数 $p^e$ ; 返回真正的 $f(p^e) mod "mo"$ . 必须保证 `f_pk(p,1,p)` 与 `sym` 给出的 $f(p)$ 相同. ],
  )
  #v(2pt)
  *求解:* `solve(n,pr,pre,tag=0)` \
  #table(
    columns: (1.05fr, 3.25fr),
    stroke: 0.35pt + luma(150),
    inset: 1.8pt,
    [*参数*], [*必须传入的内容*],
    [`n`], [要求和的正整数上界, 不取模. ],
    [`pr`], [`VI` 类型的升序质数表, `pr[0]=2`, 不放占位元素; 至少包含全部 $p<=floor sqrt(n) floor.r$ , 可以包含更多质数. ],
    [`pre`], [`VI` 类型的质数位置前缀和, 长度至少为 `pr.size()+1`. 令 `pre[0]=0`, 再依次计算 `pre[i+1]=(pre[i]+f(pr[i]))%mo`. 因而 `pre[i]` 表示前 `i` 个质数的函数值之和, 不是 $sum_(t=1)^i f(t)$ . ],
    [`tag`], [求和范围开关. 省略或传入 `0` 时返回全体位置之和 $sum_(i=1)^n f(i)$ ; 传入 `1` 时仅返回质数位置之和 $sum_(p<=n)f(p)$ , 并跳过 `dfs` 中的质数幂递归. ],
    [返回值], [`tag` 所指定的前缀和模 `mo` 的结果. `tag=0` 时模板固定按 $f(1)=1$ 处理. ],
  )
]\ 

#code-info(
  [求全体位置时调用 `solve(n,pr,pre)` 或 `solve(n,pr,pre,0)` ; 求质数位置时调用 `solve(n,pr,pre,1)` . `tag=1` 仍需要 `pr` 完成筛法, 但不会调用 `f_pk`, 且 `pre` 只会读取 `pre[0]=0`; 为复用接口仍须传入它. \
  求全体位置时, 先在线性筛中得到 `pr` 与质数处的 `f`, 据此构造完整的 `pre`; 再定义 `S_pow`、`f_pk` 并构造对象. `sym`、两个函数返回值与 `pre` 的模意义结果均须位于 $[0,"mo")$ . ],
  [令 $K$ 为 `sym.size()` . 不计外部线性筛, 两种模式的时间均为 $O(K n^(3/4)/log n)$ , 空间均为 $O(K sqrt(n))$ ; `tag=1` 跳过 `dfs`, 因而常数更小. ],
)
#code-file("code/math/min25Sieve.cpp")

#h(2em) 例如求 $sum_(i=1)^n phi(i)$ 时, 输入 `sym={mo-1,1}` ; 令 `S_pow(0,x)=x%mo`, `S_pow(1,x)=x%mo*((x+1)%mo)%mo*((mo+1)/2)%mo`; 令 `f_pk(p,e,pe)=(pe-pe/p)%mo`. 线性筛得到 `pr` 与 `phi` 后构造上述 `pre`, 最后执行 `Min25_sieve solver(sym,S_pow,f_pk)` 与 `solver.solve(n,pr,pre)` .

=== 万能欧几里德方法

#problem[
设 $(T,D,e)$ 为幺半群, 即 $D:T times T arrow T$ 满足结合律, $e$ 为双侧单位元. 给定 $u,r in T$ 以及整数 $n,a,b>=0$、$c>0$ , 记
$
  y_i=lr(floor (a i+b)/c floor.r) quad (0<=i<=n).
$
约定 $x^0=e$、$x^k=D(x^(k-1),x)$ , 求
$
  F(n,a,b,c;u,r)=u^(y_0) product_(i=1)^n (r u^(y_i-y_(i-1))).
$
]#ps[
式中的乘法均指运算 $D$ , 且乘积严格按照 $i$ 递增的顺序计算. 它等价于对直线 $y=lr(floor (a x+b)/c floor.r)$ 下方的格路径编码: 每向上一步乘入 $u$ , 每向右一步乘入 $r$ . 因为 $D$ 不要求满足交换律, 操作的先后顺序不能改变.
]
#example[取整和][
  要求
  $
    S=sum_(i=0)^(n-1) lr(floor (a i+b)/c floor.r).
  $
  取 $T=ZZ^3$ , 三元组 $(p,q,s)$ 分别记录一段操作串中的向上步数、向右步数, 以及每个向右步之前出现的向上步数之和. 对 $X=(p_1,q_1,s_1)$ 与 $Y=(p_2,q_2,s_2)$ 定义
  $
    D(X,Y)=(p_1+p_2,q_1+q_2,s_1+s_2+p_1 q_2),
  $
  单位元取 $(0,0,0)$ , 并令 $u=(1,0,0)$、$r=(0,1,0)$ . 连接 $X$ 与 $Y$ 时, $Y$ 中每个向右步之前都会多出 $p_1$ 个向上步, 因而交叉贡献为 $p_1 q_2$ , 所以 $D$ 满足结合律.

  调用 `solve(n,a,b,c,u,r)` 后, 返回三元组的第三个分量就是 $S$ . 若要求 $sum_(i=0)^N lr(floor (a i+b)/c floor.r)$ , 则调用 `solve(N+1,a,b,c,u,r)` .
]\ 

#code-info(
  [`MegaEuclid(unit,D)` 固定幺半群的单位元与结合运算; 令 $y_i=lr(floor (a i+b)/c floor.r)$ , `solve(n,a,b,c,u,r)` 返回操作串 $u^(y_0) product_(i=1)^n (r u^(y_i-y_(i-1)))$ 的幺半群积, 其中 `u`、`r` 分别表示向上、向右一步. 第 $i+1$ 个 `r` 出现于 $(i,y_i)$ , 故它编码的取整值下标范围为 $0<=i<n$ ; 若要求 $0<=i<=N$ , 应传入 `n=N+1`. ],
  [`D` 必须满足结合律, `unit` 必须是其双侧单位元; 要求 $n,a,b>=0$ 、$c>0$ , 且中间商能存入 `int`. 令 $M=max(n,a,b,c,2)$ , 在一次 `D` 运算与一次 `T` 拷贝均为 $O(1)$ 时, 递归深度为 $O(log M)$ , 每个连续操作块的幂由 `qpow` 在 $O(log M)$ 次 `D` 运算内求出, 因而总时间为 $O(log^2 M)$ , 递归栈空间为 $O(log M)$ . ],
)
#code-file("code/math/UniversalEuclid.cpp")

== 多项式

=== 复数FFT

#code-info(
  [`cmplx` 提供复数四则所需操作; `fft::work(f,tag)` 原地执行长度为二次幂的 DFT(`tag=0`)或 IDFT(`tag=1`). ],
  [长度为 $n$ 时, 时间 $O(n log n)$ , 除输入数组外额外空间 $O(1)$ . ],
)
#code-file("code/math/fft.cpp")

=== 取模全家桶

#include "../code/polynomial/polynomial.typ"

== 线性代数类

#include "../code/matrix/matrix.typ"

== 线性基

#code-info(
  [`LinearBasis(n)` 建立处理 $n$ 位整数的空线性基, 使用时须指定位数 $1<=n<=63$ , 输入满足 $0<=x<2^n$ (依赖公共模板的 64 位 `int`). `operator[](i)` 返回 `B[i]` 的引用; `proj(x)` 返回消去所有已有主元位后的剩余值, 即以 `x` 为初值异或当前基底可取得的最小值; `proj_max(x)` 返回对应的最大值. 两个查询均不改变基底. `insert(x)` 插入 `x`, 线性相关时不改变基底; `dim()` 返回当前维数. `B[i]` 非零时最高位为 $i$, 且其余主元位均为 $0$. ],
  [初始化与对象空间均为 $O(n)$ ; `operator[]` 为 $O(1)$ ; `proj`、`proj_max`、`insert`、`dim` 单次时间均为 $O(n)$ , 额外空间均为 $O(1)$ . ],
)
#code-file("code/math/linearBasis.cpp")

===& 性质与结论

以下固定满足上述主元条件的基底, 记其张成的空间为 $V$, 维数为 $r$. 查询以 $x$ 为初值, 允许再异或零个或多个基向量, 记
$
  g(x)&=op("proj")(x)=min_(v in V)(x xor v), \
  f(x)&=op("proj_max")(x)=max_(v in V)(x xor v), \
  M&=f(0)=max V.
$

#property[极值关系][
  $ f(x)=g(x) xor M, quad M=xor.big_i B[i]. $
  其中所有基向量直接异或得到 $M$ 依赖当前的最简基底形式.
]

#property[线性与仿射][
  `proj` 是线性映射, `proj_max` 是仿射映射:
  $
    g(x xor y)&=g(x) xor g(y), \
    f(x xor y)&=f(x) xor f(y) xor M.
  $
  还满足混合关系
  $
    f(x xor y)&=f(x) xor g(y), \
    g(x xor y)&=f(x) xor f(y).
  $
]

#property[幂等与吸收][
  $
    g(g(x))&=g(f(x))=g(x), \
    f(f(x))&=f(g(x))=f(x).
  $
]

#property[异或类与可表示性][
  $
    g(x)=g(y)&arrow.l.r f(x)=f(y) arrow.l.r x xor y in V, \
    x in V&arrow.l.r g(x)=0 arrow.l.r f(x)=M.
  $
]

#property[第 $k$ 小值的线性性][
  将 $V$ 中的不同元素升序排列, *包含零且下标从零开始*, 记第 $k$ 个值为 $h(k)$. 将非零基向量按主元从低到高排列为 $b_0,...,b_(r-1)$, 则
  $ h(k)=xor.big_(j:k_j=1)b_j quad (0<=k<2^r), $
  其中 $k_j$ 是 $k$ 的第 $j$ 个二进制位. 对 $0<=a,b<2^r$ 有
  $ h(a xor b)=h(a) xor h(b). $
]

#property[表示方案数][
  原序列有 $N$ 个位置, 维数为 $r$, 则不同的子集异或值共有 $2^r$ 种. 按下标区分子集, 有
  $
    op("cnt")(x)=cases(
      2^(N-r) & g(x)=0,
      0 & g(x)!=0.
    )
  $
  上式包含空集; 若只统计非空子集, 仅在目标值为 $0$ 时将答案减一.
]

#property[插入与空间扩张][
  记插入 `x` 后的空间为 $V'$, 以下 $V,f,g,M,r$ 均指插入前的状态. 若 $g(x)=0$, 则 $V'=V$, 维数不变; 否则
  $ V'=V union {x xor v:v in V}, quad op("dim")(V')=r+1, $
  且上述两部分不交, 空间大小恰好翻倍. 无论是否线性相关, 插入后的整个空间最大值均为
  $ max V'=max(M,f(x)). $
]

=== 线性基求交: Zassenhaus 算法

设两个线性基分别张成 $U,W$, 构造由二元增广行组成的空间
$ H=op("span")({(u,u):u in U} union {(w,0):w in W}). $
将第一组基向量以 `(x,x)` 插入, 第二组以 `(x,0)` 插入; 先消去第一分量, 再消去第二分量. 所得阶梯基中第一分量为 $0$ 的非零行, 其第二分量组成 $U ∩ W$ 的一组基.

实现用两个 64 位整数保存增广行. `p[k*n+i]` 保存第 `k` 个分量的第 `i` 位主元行, `k=0,1` 分别对应第一、第二分量; 最后将第二组主元行的第二分量插回结果, 得到最简基底.

#code-info(
  [`Zassenhause::work(a,b)` 返回两个线性基张成空间的交的线性基, 要求两者位数相同且 $1<=n<=63$. 依赖 `LinearBasis` 和公共模板的 `VII`. 输入不变, 返回对象可继续调用 `proj/proj_max/insert/dim`. ],
  [时间 $O(n^2)$ , 额外空间 $O(n)$. ],
)
#code-file("code/math/Zassenhaus.cpp")
