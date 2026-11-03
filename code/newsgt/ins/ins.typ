#import "../../../common.typ": *

沿用同一个 `SegmentTree` 主体, 加入本节的插入、合并、分裂片段, 再加入普通部分的 `query` 即可; 无须 `build`. 对象各自持有一个根, 空树、合并或移动后的源对象都可重新插入.

==== 插入式修改

#code-info(
  [`a.insert(x,d)` 将位置 $x$ 的值增加 $d$, 沿途缺少的节点自动建立; 越出值域时不作修改. 空树、合并后被清空的树及移动后的源对象都可继续插入. ],
  [单次时间与递归栈为 $O(log U)$ , 最多新增 $O(log U)$ 个节点, 其中 $U=R-L+1$. ],
)
#code-file("code/newsgt/ins/insert.cpp")

#block(width: 100%, breakable: false)[
==== 合并

#code-info(
  [`a.merge(b)` 将 `b` 破坏性合入 `a`, 相同位置权值相加, 随后 `b.root=0`. 要求两个对象不同且值域完全相同; 合并后 `b` 保留原值域, 可以重新插入. ],
  [时间 $O(K+1)$ , 其中 $K$ 为两棵树同时非空的节点对数; 递归栈 $O(log U)$ , 当前合并不新建节点. ],
)
#code-file("code/newsgt/ins/merge.cpp")
]

==== 分裂

#code-info(
  [`auto b=a.split(x)` 使 `a` 保留位置 `<x` 的部分, 返回树 `b` 得到位置 `>=x` 的部分. 两棵树均保留原值域, 节点互不共享; $x<=L$ 时全部交给 `b`, $x>R$ 时全部留在 `a`. ],
  [单次时间、递归栈与新增节点数均为 $O(log U)$ ; 空树或整棵划归一侧时为 $O(1)$. ],
)
#code-file("code/newsgt/ins/split.cpp")

==== 使用示例

依赖基础模板的 64 位 `int`、`write` 等定义; 将公共主体、三个动态成员片段及共用 `query` 组合后, 把下面代码放入 `solve()`.
#code-file("code/newsgt/example.cpp")
