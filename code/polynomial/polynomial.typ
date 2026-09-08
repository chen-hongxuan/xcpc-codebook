#import "../../common.typ": *

==== 通用部分

#code-info(
  [`poly(len,val)` 建立含 `len` 个系数的多项式; `f[i]` 表示 $x^i$ 的系数. `_MOD_` 与 `_G_` 分别是 NTT 模数和原根; `red` 完成一次减模, `qpow` 默认求模逆. `size`、`reduct`、`bas2_extend` 与 `operator[]` 分别用于查询长度、调整长度、补至二次幂长度及访问系数. 将其余所需片段放入结构体预留位置. ],
  [`size` 和下标访问为 $O(1)$ ; `qpow` 为 $O(log t)$ ; 长度调整的时间与新增或删除的系数数目成正比. 系数须处于 `[0,mo)`; 当前参数要求 `_MOD_=998244353`、`_G_=3`, 可用 NTT 长度不超过 $2^23$ . ],
)
#code-file("code/polynomial/struct.cpp")

==== FFT

#code-info(
  [`fft(opt)` 原地执行数论变换; `opt=0` 为 NTT, `opt=1` 为 INTT. 调用时长度必须是 `_MOD_-1` 的二次幂因子, 通常先使用 `bas2_extend`. ],
  [长度为 $n$ 时, 时间为 $O(n log n)$ , 除输入数组外额外空间为 $O(1)$ . ],
)
#code-file("code/polynomial/fft.cpp")

==== 乘法

#code-info(
  [`A*B` 使用 NTT 返回卷积, 结果恰好保留 `A.size()+B.size()-1` 个系数; 任一操作数为空时返回空多项式. 依赖 FFT 片段. ],
  [令 $L$ 为不小于结果长度的最小二次幂, 时间为 $O(L log L)$ , 额外空间为 $O(L)$ . ],
)
#code-file("code/polynomial/multiply.cpp")

==== 加法

#code-info(
  [`A+B` 返回逐项和, 短多项式缺少的高次项视为 $0$ . ],
  [时间与结果空间均为 $O(max(n,m))$ . ],
)
#code-file("code/polynomial/add.cpp")

==== 减法

#code-info(
  [`A-B` 返回逐项差, 短多项式缺少的高次项视为 $0$ . ],
  [时间与结果空间均为 $O(max(n,m))$ . ],
)
#code-file("code/polynomial/subtract.cpp")

==== 求逆

#code-info(
  [`A.inverse()` 使用牛顿迭代返回与 `A` 等长的形式幂级数逆 $B$ , 满足 $A B equiv 1 mod x^n$ . 要求 `A` 非空且常数项非零, 并依赖乘法片段. ],
  [时间为 $O(n log n)$ , 额外空间为 $O(n)$ . ],
)
#code-file("code/polynomial/inverse.cpp")

==== 求导

#code-info(
  [`A.derivate()` 返回形式导数; 常数或空多项式的导数表示为空多项式. ],
  [时间与结果空间均为 $O(n)$ . ],
)
#code-file("code/polynomial/derivate.cpp")

==== 积分

#code-info(
  [`A.integral()` 返回常数项为 $0$ 的形式积分, 并在线性时间内递推所需模逆. 要求 `A.size()<mo`, 使所有分母均可逆. ],
  [时间与结果空间均为 $O(n)$ . ],
)
#code-file("code/polynomial/integral.cpp")

==== 取对数

#code-info(
  [`A.logarithm()` 根据 $ln A=integral A'/A$ 返回与 `A` 等长的形式幂级数对数. 要求 `A` 非空且常数项为 $1$ ; 依赖乘法、求逆、求导与积分片段. ],
  [时间为 $O(n log n)$ , 额外空间为 $O(n)$ . ],
)
#code-file("code/polynomial/logarithm.cpp")

==== 指数

#code-info(
  [`A.exponential()` 使用 $G <- G(1-ln G+A)$ 的牛顿迭代返回 $exp A mod x^n$ . 要求 `A` 非空且常数项为 $0$ ; 依赖减法、乘法与取对数片段. ],
  [时间为 $O(n log n)$ , 额外空间为 $O(n)$ . ],
)
#code-file("code/polynomial/exponential.cpp")

==== 幂

#code-info(
  [`A.power(k)` 根据 $A^k=exp(k ln A)$ 返回与 `A` 等长的幂. 当前基础版本要求 `A` 非空且常数项为 $1$ ; `k` 可为负数. 依赖取对数与指数片段. ],
  [时间为 $O(n log n)$ , 额外空间为 $O(n)$ . ],
)
#code-file("code/polynomial/power.cpp")

==== 平方根

#code-info(
  [`A.sqrt()` 使用 $G <- (G+A/G)/2$ 返回常数项为 $1$ 的平方根, 满足 $G^2 equiv A mod x^n$ . 当前基础版本要求 `A` 非空且常数项为 $1$ ; 依赖加法、乘法与求逆片段. ],
  [时间为 $O(n log n)$ , 额外空间为 $O(n)$ . ],
)
#code-file("code/polynomial/sqrt.cpp")

==== 除法与取模

#code-info(
  [`shrink()` 原地删除高次零项. `A.divmod(B)` 返回 `[Q,R]`, 也可分别使用 `A/B` 与 `A%B`; 满足 $A=B Q+R$ 且 $deg R<deg B$ . 除数必须是非零多项式; 当 $deg A<deg B$ 时, 商为空而余数为去除高次零项后的 `A`. ],
  [令 $n=max(deg A,deg B)+1$ , 时间为 $O(n log n)$ , 额外空间为 $O(n)$ . ],
)
#code-file("code/polynomial/divmod.cpp")
