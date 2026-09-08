#import "../common.typ": *

= 数据结构 / Data Structure

== 树状数组

#code-info(
  [`BitTree(n)` 初始化下标 $1$ 到 $n$ ; `add(x,t)` 单点加; `ask(x)` 求前缀和; `find(v)` 求最小的满足前缀和不小于 $v$ 的位置. 要求 $n>0$ 、更新下标合法且各点权非负; $v<=0$ 时返回 $0$ , 不存在时返回 $n+1$ . ],
  [初始化与空间 $O(n)$ ; 三种操作均为 $O(log n)$ 时间、$O(1)$ 额外空间. ],
)
#code-file("code/data-structure/bittree.cpp")

== 线段树系列

// === 主席树

// #code-info(
//   [`ChairmanTree()` 建立空版本 `root[0]=0`; `modify(p,l,r,x,d)` 从旧根派生单点加版本并返回新根, 返回值须由调用者保存; `query(p,q,...)` 求版本 $p-q$ 的区间和; `kth(p,q,...)` 求版本差中的第 $k$ 小. ],
//   [设值域大小为 $U$ : 修改、查询、`kth` 均为 $O(log U)$ ; 每次修改新增 $O(log U)$ 节点, $M$ 次修改后空间 $O(M log U)$ . `kth` 要求版本差为非负频数, 且 $1<=k$ 、`k<=val(p,q)`. ],
// )
// #code-file("code/data-structure/jtree.cpp")

// === 可裂&可并线段树

// #code-info(
//   [`segmenttree2(L,R,n)` 设置值域并预留节点, 树根由外部以整数维护且初值为 $0$ ; `modify/query/find` 分别完成单点加、区间和、第 $k$ 小; `merge(p,q)` 将 $q$ 破坏性合入 $p$ ; `split(p,q,x)` 使 $q$ 保留值域 $<x$ 的部分, $p$ 得到 $>=x$ 的部分. ],
//   [值域大小为 $U$ 时, 修改、查询、`find` 与 `split` 为 $O(log U)$ ; `merge` 为 $O(min(A_p,A_q))$ ; 空间按历史分配节点数计算. 第 $k$ 小要求节点权值非负. ],
// )
// #code-file("code/data-structure/sgmTree.cpp")

// === 线段树二分

// #code-info(
//   [`max_right(...,ql,s,v)`/`min_left(...,qr,s,v)` 分别向右/左寻找累计和首次达到 $v$ 的位置, 要求区间和具有单调性. ],
//   [正确实现时单次时间与递归栈均为 $O(log n)$ ; 当前 `max_right` 的整段判定方向写反, 结果与复杂度暂无保证. ],
// )
// #code-file("code/data-structure/sgtBisearch.cpp")

#include "../code/sgt/sgt.typ"

=== 势能线段树

#h(2em)准确来讲, 势能线段树并不是某种功能实现范式, 而是通过赋予线段树节点势能的方式来证明某些在线段树上的"暴力"操作的时间复杂度是合法的. 以下提供若干势能线段树的例子.\ \ 

#let hr = line(length: 100%)

#example[1][
  维护序列 $chevron a_i chevron.r$ , 支持
  1. 给出 $l,r,v$ , 对全体 $i in [l,r]$ 执行 $a_i <- min(a_i,v)$ .
  2. 给出 $x,v$ , 执行 $a_x <- v$ .
  3. 给出 $l,r$ , 回答 $sum_(i in[l,r]) a_i$

  *solution:* 线段树的节点维护区间权值和 sum , 最大值 max#sub[1] , 次大值 max#sub[2] 以及最大值的个数 cnt ; 懒标记维护上一次 pushdown 之后在这个节点上进行的操作1的 $v$ 的最小值. 我们只考虑维护操作 1 , 首先把修改分解为散块, 如果 $v>=max_1$ 则不作修改; 若 $max_1>v>max_2$ 则在懒标记上修改; 若 $max_2>=v$ 则递归下去.\
  #h(2em)我们定义每个节点的势能是这个节点掌管的区间中有多少不同的数, 整棵树的势能是全体节点的势能之和. 每次单点修改会使得总势能增加 $O(log N)$ , 初始势能为 $O(N log N)$ , 每次(分解后的)递归操作会使得递归下去的那个节点的势能至少减少 $1$ 因此递归的总次数不超过 $O(N log N)$ .
]

#example[2][
  维护序列 $chevron a_i (<=10^9) chevron.r$ , 支持
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
  [`split(...,opt=0)` 按 `<d` 与 `>=d` 分裂, `opt!=0` 按 `<=d` 与 `>d` 分裂; `merge` 合并有序树; `insert/remove` 增加或删除一个值; `rank/kth/pre/nxt` 求排名、第 $k$ 小、严格前驱与后继. ],
  [除 `size/empty` 为 $O(1)$ 外, 核心操作期望 $O(log n)$ 、最坏 $O(n)$ ; `merge` 要求左树所有值不大于右树, `kth/pre/nxt` 要求答案存在; 删除不回收节点. ],
)
#code-file("code/data-structure/fhqtreap.cpp")
