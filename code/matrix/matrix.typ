#import "../../common.typ": *

=== 主体框架

#code-info(
  [`matrix()` 建立空哨兵; `matrix(n,m,v)` 建立 $n times m$ 常数矩阵; `matrix(n)` 建立 $n$ 阶单位阵; `a/n/m` 保存元素与尺寸, `operator[]` 提供行访问. 将 `_P_` 换成质数模数, 直接写入的元素须位于 `[0,mo)`, 再把需要的成员函数片段放入结构体预留位置. ],
  [构造常数矩阵为 $O(n m)$ , 构造单位阵为 $O(n^2)$ ; 空矩阵与行访问为 $O(1)$ , 存储空间为 $O(n m)$ . ],
)
#code-file("code/matrix/struct.cpp")

=== 乘法与快速幂

#code-info(
  [`A*B` 返回矩阵乘积, 要求 `A.m==B.n`; `A.fpow(t)` 返回方阵的 $t$ 次幂, 要求 $t>=0$ . 尺寸或指数非法时返回空哨兵. ],
  [$n times k$ 矩阵乘 $k times m$ 矩阵的时间为 $O(n k m)$ , 额外空间为 $O(n m)$ ; $n$ 阶方阵快速幂的时间为 $O(n^3 log t)$ . ],
)
#code-file("code/matrix/multiply.cpp")

=== 加法

#code-info(
  [`A+B` 返回逐项和, 两个矩阵的尺寸必须相同; 尺寸不同时返回空哨兵. ],
  [时间与结果空间均为 $O(n m)$ . ],
)
#code-file("code/matrix/add.cpp")

=== 减法

#code-info(
  [`A-B` 返回逐项差, 两个矩阵的尺寸必须相同; 尺寸不同时返回空哨兵. ],
  [时间与结果空间均为 $O(n m)$ . ],
)
#code-file("code/matrix/subtract.cpp")

#block(width: 100%, breakable: false)[
  === `+=`

  #code-info(
    [`A+=B` 是 `A=A+B` 的简写并返回 `A` 的引用; 尺寸不同时把 `A` 置为空哨兵. 该 `friend` 运算符依赖加法片段. ],
    [时间与临时结果空间均为 $O(n m)$ . ],
  )
  #code-file("code/matrix/add-assign.cpp")
]

#block(width: 100%, breakable: false)[
  === `-=`

  #code-info(
    [`A-=B` 是 `A=A-B` 的简写并返回 `A` 的引用; 尺寸不同时把 `A` 置为空哨兵. 该 `friend` 运算符依赖减法片段. ],
    [时间与临时结果空间均为 $O(n m)$ . ],
  )
  #code-file("code/matrix/subtract-assign.cpp")
]

#block(width: 100%, breakable: false)[
  === `*=`

  #code-info(
    [`A*=B` 与 `A*=x` 分别是 `A=A*B` 与 `A=A*x` 的简写, 均返回 `A` 的引用. 矩阵右乘要求 `A.m==B.n`, 否则把 `A` 置为空哨兵. 该 `friend` 运算符依赖矩阵乘法与数乘片段. ],
    [$n times k$ 矩阵右乘 $k times m$ 矩阵的时间为 $O(n k m)$ , 数乘时间为 $O(n m)$ ; 临时结果空间均为 $O(n m)$ . ],
  )
  #code-file("code/matrix/multiply-assign.cpp")
]

=== 矩阵数乘

#code-info(
  [`A*x` 与 `x*A` 均返回矩阵的模意义数乘, 标量 $x$ 可以为负数. ],
  [时间与结果空间均为 $O(n m)$ . ],
)
#code-file("code/matrix/scalar-multiply.cpp")

=== 高斯消元

#code-info(
  [`A.gauss(opt)` 对前 $n$ 列执行模意义 Gauss--Jordan 消元, 要求 $0<n<=m$ 且模数为质数. 返回矩阵的主元没有归一化; `opt=1` 时把换行导致的行列式符号计入第一个主元. ],
  [对 $n times m$ 矩阵, 时间为 $O(n^2 m)$ , 返回值空间为 $O(n m)$ , 其余额外空间为 $O(n)$ . ],
)
#code-file("code/matrix/gauss.cpp")

=== 行列式

#code-info(
  [`A.det()` 返回方阵行列式; 非方阵返回 $-1$ , 奇异方阵返回 $0$ . 依赖高斯消元片段. ],
  [对 $n$ 阶方阵, 时间为 $O(n^3)$ , 额外空间为 $O(n^2)$ . ],
)
#code-file("code/matrix/determinant.cpp")

=== 求逆

#code-info(
  [`A.inv()` 使用增广矩阵返回方阵的逆; 非方阵或奇异方阵返回空哨兵. 依赖高斯消元片段. ],
  [对 $n$ 阶方阵, 时间为 $O(n^3)$ , 额外空间为 $O(n^2)$ . ],
)
#code-file("code/matrix/inverse.cpp")
