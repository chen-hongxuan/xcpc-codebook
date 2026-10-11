#import "../../common.typ": *

=== 公共结构与预处理

#h(2em) 长儿子 `son[u]` 按子树高度选择, `h[u]` 为从 $u$ 出发的最长向下路径的点数. 公共结构只维护树和链的信息, DP 状态由调用者保存. 将下方 `init` 放入预留位置, 即可用于普通 `VI` 的长剖 DP.

#code-info(
  [`init(edge,root=1)` 处理点编号为 $1,...,n$ 的连通树, `edge` 为双向加入无向边的 `vector<VI>`. 生成 `fa,h,son,ord,bel,head`; `ord` 中父亲在儿子之前, `bel[u]` 是从 $0$ 开始的链编号, `head[id]` 为对应链头. ],
  [时间、额外空间均为 $O(n)$ ; 使用迭代遍历, 所有长链的长度之和为 $n$ . ],
)
#code-file("code/longchain/struct.cpp")
#code-file("code/longchain/init.cpp")

=== 直接使用 vector

#h(2em) 求每点子树内与它距离为 `K` 的后代数, 其中 `K>=0`. 用 `f[u]` 倒序记录各深度的计数, 距离 $k$ 对应下标 `f[u].size()-1-k`. `swap` 直接继承长儿子, 短儿子按深度累加; 最后 `push_back(1)` 加入当前点, 使原有状态的距离整体加 $1$ . 此示例只需公共结构与 `init`, 放在已输入 `n,edge,K` 的 `solve` 中.

#code-info(
  [`ans[u]` 为所求计数, 超过子树高度时为 $0$ . 短儿子合并后释放其数组; 父亲继承前须保存儿子的答案. `swap` 后长儿子的数组已交给父亲. ],
  [时间、空间均为 $O(n)$ . `swap` 为 $O(1)$ , `push_back` 均摊 $O(1)$ ; 所有短儿子高度之和为 $n-h["root"]$ . ],
)
#code-file("code/longchain/work.cpp")

#block(width: 100%, breakable: false)[
=== 可选: 下标平移与连续存储映射

#h(2em) 需要正负下标平移或固定容量时, 将以下字段和成员函数放入 `LongChain`. 每链只记录固定坐标左端点 `l` 和宽度 `w`, 存储结构由外部创建. 逻辑下标 $x$ 映射到从 $0$ 开始的链内位置
$ p=x-"off"[u]-c["bel"[u]].l. $

#code-info(
  [使用前先调用下一节的 `plan`. `inherit(u)` 接管长儿子的偏移, 叶子偏移置 $0$ ; `shift(u,d)` 令原来的 $f[x]$ 成为 $f[x+d]$ . `pos(u,x)` 转换单点下标; `range(u,L,R)` 转换闭区间并与 $[0,w-1]$ 取交, 返回 `l>r` 表示空. 单点读写须保证转换后下标在范围内. ],
  [继承、平移和下标转换均为 $O(1)$ ; 这些操作只改变坐标视图. ],
)
#code-file("code/longchain/index.cpp")
]

#ps[
  按 `bel` 存储时, 同一长链上的点访问同一个数组或线段树根. 复用为破坏性的, 修改父亲后长儿子的旧 DP 不再独立保存. 若一次短儿子合并需要读完整的旧父状态, 应先收集转移结果, 再统一写回.
]

=== 可选: 状态范围规划

#code-info(
  [`plan(L,R,d)` 在 `init` 后调用, 三个数组均按原树点编号. $[L[u],R[u]]$ 覆盖处理 $u$ 时所有可能状态, 要求 $L[u]<=R[u]$ ; `d[u]` 是继承后计划进行的平移, 包括叶子的平移. 计算每链的 `c[id]={l,w}` 并将运行时偏移置 $0$ ; 外部按 `w` 分配存储, DP 中先 `inherit(u)` 再 `shift(u,d[u])`. 重新 `init` 后须重新 `plan`. ],
  [规划时间、空间均为 $O(n)$ . 记各链宽度之和为 $W$ , 外部数组或完整线段树空间为 $O(W)$ ; 若 $|L[u]|,|R[u]|=O(h[u])$ 且 $|d[u]|=O(1)$ , 则 $W=O(n)$ . ],
)
#code-file("code/longchain/build.cpp")

#h(2em) 规划时计算 $o_u=d_u+o_("son"[u])$, 无长儿子时取 $o_0=0$. 将 $[L[u]-o_u,R[u]-o_u]$ 与长儿子所需区间取包络, 链头得到该链容量. 额外平移或插入新下标时, 仍须保证转换后的位置落在预留范围内, 且下标运算不溢出.

=== 组装存储结构

#h(2em) 使用映射模块时, 按链编号创建外部存储. 数组接法如下, 初始值按题意设置:
```cpp
vector<VI> f(lc.head.size());
for(int id=0;id<f.size();++id)
  f[id].assign(lc.c[id].w,0);
//逻辑下标x的值: f[lc.bel[u]][lc.pos(u,x)]
```

线段树接法为每链一个根 `rt[id]`, 在 $[0,c[id].w-1]$ 上使用现有普通建树模块, 所有根共用一个 `SegmentTree` 的节点池. 逻辑区间先经 `range` 转换, 再调用线段树的查询或修改. 数据的合并、区间标记、空状态单位元与操作复杂度均由所选维护结构决定.

=== 使用现有线段树的示例

#h(2em) 求每点子树内距离属于 $[A[u],B[u]]$ 的后代数. 将公共结构、`init`、两个可选片段组合为 `LongChain`, 线段树组合公共结构与普通的建树、单点加、区间和模块. 代码放在已输入 `n,edge,A,B` 的 `solve` 中.

#code-info(
  [`ans[u]` 为所求计数. 长儿子与父亲使用同一个根, 只平移坐标; 短儿子逐深度查询后累加到父状态. ],
  [时间 $O(n log n)$ , 空间 $O(n)$ . 本例各链容量之和为 $n$ , 总枚举量为 $O(n)$ . ],
)
#code-file("code/longchain/segment.cpp")

#block(width: 100%, breakable: false)[
=== 接入其他维护信息

#h(2em) 区间加、区间最大值可组合线段树章节的对应模块: `seg.change(rt[id],lc.pos(u,x),v)` 单点取最大值, `range` 转换后调用 `seg.modify/seg.query`; 整链加用 `seg.apply(rt[id],v)`, 整链最大值读 `seg.tr[rt[id]].val`. 空状态及以后新插入状态的处理由该线段树模块完成.

若线段树按链内位置 $p$ 维护 $max(f+C p)$ 与 $max(f-C p)$ , 记 $t="off"[u]+c["bel"[u]].l$ , 则逻辑下标 $x=p+t$ 下的查询值为
$
  max(f+C x)=max(f+C p)+C t,\
  max(f-C x)=max(f-C p)-C t.
$
]
