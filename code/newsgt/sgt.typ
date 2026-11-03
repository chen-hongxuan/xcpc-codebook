#import "../../common.typ": *

===& 公共结构

#code-info(
  [`SegmentTree(l,r)` 建立值域为 $[l,r]$ 的空树, 要求 $l<=r$. 每个对象只有一个 `root`, 初值为 $0$; 所有对象共用节点池, `tr[0]` 为空节点. 按需改写 `node`、`pushup/pushdown`, 将下方需要的成员片段放入预留位置. 普通树、动态树和主席树沿用同一个主体. ],
  [构造与移动为 $O(1)$ ; `newnode` 均摊 $O(1)$ ; 总空间为 $O(P)$ , 其中 $P$ 为共享池历史分配节点数. ],
)
#code-file("code/newsgt/struct.cpp")

对象禁止普通复制, 使用 `move` 转移根, 源对象随后为空. `SegmentTree::clear()` 清空整个节点池, 仅在所有树及外部版本根都不再使用时调用; 节点暂不单独回收. 当前维护区间和, 单点操作不需要懒标记; 扩展区间修改时须补齐对应标记与空子树处理.

=== 普通(静态)线段树

#block(width: 100%, breakable: false)[
  ==== 建树

  #code-info(
    [`a.build()` 在对象值域内完整建树, 节点初值为 $0$. 普通线段树使用前调用; 动态树与主席树可直接从空树开始. 保留 `build(p,l,r)` 递归接口, 此时 `p` 须为已分配节点. ],
    [令 $U=R-L+1$ , 时间与新增空间均为 $O(U)$ , 递归栈为 $O(log U)$ . ],
  )
  #code-file("code/newsgt/normal/build.cpp")
]

==== 单点加

#code-info(
  [`a.modify(x,d)` 将位置 $x$ 的权值增加 $d$. 调用前须已完整建树; 空树或 $x$ 越界时不作修改. 保留 `modify(p,x,d)` 递归接口. 若维护的不是区间和, 需要同步改写叶节点操作与 `pushup`. ],
  [单次时间和递归栈均为 $O(log U)$ . ],
)
#code-file("code/newsgt/normal/add.cpp")

==== 区间修改框架

#code-info(
  [`modify(root,L,R,d)` 是通用区间修改框架. 须按题意补齐整段修改处及 `pushdown`, 并保证 `pushup` 与维护信息一致; 例如区间加与区间和需将整段的 `val` 增加 `(r-l+1)*d`, 同时累计加法标记. 三参单点加为独立片段, 可按需组合. ],
  [标记操作与合并为 $O(1)$ 时, 单次时间与递归栈为 $O(log U)$ . ],
)
#code-file("code/newsgt/normal/modify.cpp")

==== 查询

#code-info(
  [`a.query(l,r)` 返回对象值域与 $[l,r]$ 交集的权值和; 空节点、空交集及 $l>r$ 返回 $0$. 普通树与动态树共用本片段; 保留 `query(p,l,r)` 递归接口. 改写维护信息时也须调整合并运算的单位元. ],
  [单次时间和递归栈均为 $O(log U)$ . ],
)
#code-file("code/newsgt/normal/query.cpp")

若改为维护区间最大值: `pushup` 与查询合并均改为 `max`, 查询初值和不相交返回值改为 `-inf`; 区间加整段执行 `val+=d,tag+=d`, 下传同理; 单点取最大值只需下传到叶子后执行 `chmax(val,v)`. 若用 `-inf` 表示空状态, 节点初值也设为 `-inf`, 且加法更新跳过空状态.

==== 使用示例

#code-file("code/newsgt/normal/example.cpp")

==== 线段树二分

#code-info(
  [`s` 先置为已有累计值, `max_Right(root,ql,s,v)` 返回满足 $s+sum_(i=q_l)^r a_i<=v$ 的最大右端点 $r$ ; 若起点即不满足则返回 $q_l-1$ . 函数结束后 `s` 保存已接纳部分的累计值. 要求 `ql` 位于根区间, 且判定关于右端点单调, 例如各点权非负. ],
  [单次时间和递归栈均为 $O(log U)$ . ],
)
#code-file("code/newsgt/normal/max_Right.cpp")

#code-info(
  [`s` 先置为已有累计值, `min_Left(root,qr,s,v)` 从右向左累计, 返回满足 $s+sum_(i=l)^(q_r) a_i<=v$ 的最小左端点 $l$ ; 若终点即不满足则返回 $q_r+1$ . 要求 `qr` 位于根区间, 且判定关于左端点单调. ],
  [单次时间和递归栈均为 $O(log U)$ . ],
)
#code-file("code/newsgt/normal/min_Left.cpp")

=== 动态开点线段树

#include "ins/ins.typ"

=== 主席树

==== 主席树公共结构


#code-info(
  [沿用公共主体, 每个 `SegmentTree` 对象代表一个版本; 可用外部 `vector<SegmentTree>` 保存版本. 初始 `root=0` 是空版本, 无须 `build`. `clone(p)` 只复制节点, 未修改的子树继续共享. 本节实现单点加与区间和, 不使用懒标记. ],
  [空版本构造为 $O(1)$ ; `clone` 均摊 $O(1)$ ; $M$ 次修改后节点空间为 $O(M log U)$ , 其中 $U=R-L+1$. ],
)
#code-file("code/newsgt/jtree/bas.cpp")

==== 主席树修改


#code-info(
  [`auto b=a.jmodify(x,d)` 返回将位置 $x$ 增加 $d$ 后的新版本, `a` 及所有旧节点保持不变; 越界时返回内容相同的版本. 已有节点先复制, 空节点按当前区间建立; 保留 `jmodify(p,x,d)` 返回新根的接口, `p=0` 时采用当前对象的值域. ],
  [单次时间与递归栈均为 $O(log U)$ , 最多新增 $O(log U)$ 个节点. ],
)
#code-file("code/newsgt/jtree/jmodify.cpp")

#block(width: 100%, breakable: false)[
==== 主席树查询


#code-info(
  [`a.jquery(b,l,r)` 返回版本 `a` 减去版本 `b` 后在 $[l,r]$ 内的权值和, 要求值域相同; 结果可为负. 保留 `jquery(p,q,l,r)` 根编号接口, 编号 $0$ 可作空版本. 单个版本的区间和共用普通部分的 `query`. ],
  [时间与递归栈均为 $O(log U)$ ; 查询只读, 不新建节点. ],
)
#code-file("code/newsgt/jtree/jquery.cpp")
]

==== 主席树前 $k$ 名


#code-info(
  [`a.kth(b,k)` 返回版本差 `a-b` 的第 $k$ 小下标, `a.kth(k)` 查询单个版本. 要求值域相同, 且各位置的差为非负频数; 单版本要求自身频数非负. 当 $k<=0$ 或 $k$ 大于总频数时返回 $-1$. 保留 `kth(p,q,k)` 与 `kth(p,k)` 根编号接口. ],
  [时间为 $O(log U)$ , 额外空间 $O(1)$ ; 查询只读, 不新建节点. ],
)
#code-file("code/newsgt/jtree/kth.cpp")

==== 使用示例

版本之间会共享节点; 派生历史版本后, 不对它们执行 `build/modify/insert/merge/split` 等原地修改. 新版本通过 `jmodify` 产生; `query/jquery/kth` 可反复读取. 依赖公共主体、`clone`、三个主席树操作片段以及共用的 `normal/query.cpp`.
#code-file("code/newsgt/jtree/example.cpp")

区间第 $k$ 小的常见用法: 将原数组离散化到 $[1,m]$, 按顺序执行 `v.push_back(v.back().jmodify(x,1))`, 则原数组 $[l,r]$ 中第 $k$ 小的排名为 `v[r].kth(v[l-1],k)`, 再映射回原值.

#block(width: 100%, breakable: false)[
==== 应用: 静态区间第 $k$ 小

#code-info(
  [沿用上例的成员片段, 将代码放入 `solve()`. 配合基础 `main` 时, 输入最前面是测试组数; 每组先读 `n,q` 和 $n$ 个数, 再读 $q$ 组 `l,r,k`, 输出原数组闭区间 $[l,r]$ 的第 $k$ 小原值. 要求 $n>=1$, $1<=l<=r<=n$, $1<=k<=r-l+1$. ],
  [令 $m$ 为不同值数量, 预处理 $O(n log(n+1))$ , 单次询问 $O(log(m+1))$ , 节点空间 $O(n log(m+1))$. ],
)
#code-file("code/newsgt/jtree/range-kth.cpp")
]
