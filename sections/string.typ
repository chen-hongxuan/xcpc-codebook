#import "../common.typ": *

= 字符串 / String

== 算法

=== 哈希类(三哈希)

#code-info(
  [`HASH(x)`/`HASH(x,y,z)` 构造三元哈希；`[]` 访问分量；`+=,-=,*=` 及对应二元运算逐模计算；`==,!=,<` 比较三元组。使用前须替换 `MOD` 与 `BASE`，并保证构造值、`BASE` 及经 `[]` 写入的值均在对应的 `[0,MOD)` 内。],
  [模数个数固定为 $3$，所有接口的时间与额外空间均为 $O(1)$；乘法中间积须能由 `long long` 表示。],
)
#code-file("code/string/hash.cpp")

=== AC自动机

#code-info(
  [`init()` 清空；`insert(str)` 插入小写模式串并返回终点；`construct()` 构造 fail 指针并补全转移；`cnt[p]` 记录以 $p$ 结尾的模式串数。须依次执行 `init()`、若干次 `insert()`、一次 `construct()`，重新构建前再次初始化。],
  [设模式总长为 $L$、状态数为 $P$：插入总计 $O(L)$，构造 $O(P)$，空间 $O(P)$。],
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
  [`work(s,sa,opt)` 将第 $i$ 小后缀的起点写入 `sa[i]`；`opt=0` 时 `rk[0]` 为最终后缀排名，`opt!=0` 时 `rk[i][j]` 为从 $j$ 开始、长度至多 $2^i$ 的前缀排名，越过串尾处补最小哨兵。要求字符串仅含小写字母。],
  [时间 $O(n log^2 n)$；`opt=0` 空间 $O(n)$，`opt!=0` 空间 $O(n log n)$。],
)
#code-file("code/string/sa.cpp")

== 结论
