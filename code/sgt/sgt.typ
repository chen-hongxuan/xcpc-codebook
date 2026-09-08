#import "../../common.typ": *

=== 公共结构

#code-info(
  [`SegmentTree(l,r)` 建立值域为 $[l,r]$ 的根 `root=1`, `tr[0]` 作为空节点; 按需改写 `node`、`pushup` 与 `pushdown`, 再将后续需要的成员函数片段放入结构体预留位置. `newnode` 分配节点, `lc/rc` 返回左右儿子编号的引用. ],
  [初始化为 $O(1)$ ; `newnode` 均摊 $O(1)$ ; 总空间为 $O(P)$ , 其中 $P$ 为已分配节点数. ],
)
#code-file("code/sgt/struct.cpp")

=== 普通(静态)线段树

#block(width: 100%, breakable: false)[
  ==== 建树

  #code-info(
    [`build(root,l,r)` 递归建立完整线段树, 并把每个节点的端点写入 `tr`. 普通线段树及当前主席树模块使用前应先调用一次, 并要求 $l<=r$ . ],
    [令 $U=r-l+1$ , 时间与新增空间均为 $O(U)$ , 递归栈为 $O(log U)$ . ],
  )
  #code-file("code/sgt/normal/build.cpp")
]

==== 修改

#code-info(
  [`modify(root,x,d)` 将位置 $x$ 的权值增加 $d$ . 调用前须已完整建树并保证 $x$ 位于根区间; 若维护的不是区间和, 需要同步改写叶节点操作与 `pushup`. ],
  [单次时间和递归栈均为 $O(log U)$ . ],
)
#code-file("code/sgt/normal/modify.cpp")

==== 查询

#code-info(
  [`query(root,L,R)` 返回根区间与 $[L,R]$ 交集的权值和, 完全不相交时返回 $0$ . 其中 $0$ 是当前合并运算的单位元, 改写维护信息时也要调整该返回值. ],
  [单次时间和递归栈均为 $O(log U)$ . ],
)
#code-file("code/sgt/normal/query.cpp")

==== 线段树二分

#code-info(
  [`s` 先置为已有累计值, `max_Right(root,ql,s,v)` 返回满足 $s+sum_(i=q_l)^r a_i<=v$ 的最大右端点 $r$ ; 若起点即不满足则返回 $q_l-1$ . 函数结束后 `s` 保存已接纳部分的累计值. 要求 `ql` 位于根区间, 且判定关于右端点单调, 例如各点权非负. ],
  [单次时间和递归栈均为 $O(log U)$ . ],
)
#code-file("code/sgt/normal/max_Right.cpp")

#code-info(
  [`s` 先置为已有累计值, `min_Left(root,qr,s,v)` 从右向左累计, 返回满足 $s+sum_(i=l)^(q_r) a_i<=v$ 的最小左端点 $l$ ; 若终点即不满足则返回 $q_r+1$ . 要求 `qr` 位于根区间, 且判定关于左端点单调. ],
  [单次时间和递归栈均为 $O(log U)$ . ],
)
#code-file("code/sgt/normal/min_Left.cpp")

=== 动态开点线段树

==== 插入式修改

#code-info(
  [`insert(root,x,d)` 在不预先 `build` 的情况下将位置 $x$ 增加 $d$ , 沿途缺少的节点会自动建立; 越出根区间时不作修改. 若懒标记可能非空, `pushdown` 还必须能正确处理尚未建立的孩子. ],
  [单次时间与递归栈为 $O(log U)$ , 最多新增 $O(log U)$ 个节点. ],
)
#code-file("code/sgt/ins/insert.cpp")

#block(width: 100%, breakable: false)[
==== 合并

#code-info(
  [`p=merge(p,q)` 将 $q$ 破坏性合入 $p$ 并返回新根; 两棵树对应节点的区间端点必须对齐. 合并后应令 `q=0`, 因为返回树可能直接复用了 $q$ 的节点. ],
  [忽略 `pushdown` 可能产生的新节点, 时间为 $O(K)$ , 其中 $K$ 是两棵树同时存在的节点对数; 函数本身不分配节点, 递归栈为 $O(log U)$ . ],
)
#code-file("code/sgt/ins/merge.cpp")
]

==== 分裂

#code-info(
  [`auto [a,b]=split(q,x)` 按值域分裂, $a$ 保留所有下标 `<x` 的权值, $b$ 保留所有下标 `>=x` 的权值; 必须接收两个返回根, 原来的 $q$ 不再表示完整原树. ],
  [忽略 `pushdown` 额外开点, 单次时间、递归栈与新增祖先节点均为 $O(log U)$ . ],
)
#code-file("code/sgt/ins/split.cpp")

=== 主席树

==== 主席树公共结构


#code-info(
  [`clone(p)` 复制节点 $p$ 并返回新编号; 版本根可依次存入 `rootlist`. 存在懒标记时必须实现 `jpushdown`: 先复制即将被修改的共享孩子, 再调用普通 `pushdown`; 无标记或叶节点时应直接返回. ],
  [`clone` 均摊 $O(1)$ ; 一次安全下传最多复制常数个孩子. 总空间按全部历史版本分配的节点数计算. ],
)
#code-file("code/sgt/jtree/bas.cpp")

==== 主席树修改


#code-info(
  [`rootlist.push_back(jmodify(rootlist.back(),x,d))` 从旧根派生新版本, 并将位置 $x$ 增加 $d$ ; 返回值必须保存. 当前实现要求事先完整建树, 且 `jpushdown` 不得修改旧版本仍共享的孩子. ],
  [单次时间与递归栈均为 $O(log U)$ , 新增 $O(log U)$ 个节点; 安全下传只改变常数因子. ],
)
#code-file("code/sgt/jtree/jmodify.cpp")

==== 主席树查询


#code-info(
  [`jquery(p,q,L,R)` 返回版本 $p$ 减去版本 $q$ 后在 $[L,R]$ 内的权值和; 两个根必须来自同一值域, 编号 $0$ 可作为空版本. 结果不要求非负. ],
  [时间与递归栈均为 $O(log U)$ ; 若 `jpushdown` 在查询中复制孩子, 还会新增 $O(log U)$ 个节点. ],
)
#code-file("code/sgt/jtree/jquery.cpp")

==== 主席树前 $k$ 名


#code-info(
  [`kth(p,q,k)` 返回版本差 $p-q$ 所表示多重集合中的第 $k$ 小下标, `kth(p,k)` 等价于令 $q=0$ . 要求各点版本差非负; 当 $k<=0$ 或 $k$ 大于总权值时返回 $-1$ . ],
  [时间与递归栈均为 $O(log U)$ ; 查询下传懒标记时可能额外新增 $O(log U)$ 个节点. ],
)
#code-file("code/sgt/jtree/kth.cpp")
