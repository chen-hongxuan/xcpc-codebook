# QOJ 20236 All Closed：动态投影与纤维计数

## 1. 题意与线性代数表述

把所有 $m$ 位二进制数看成向量空间

$$
E=\mathbb F_2^m,
$$

其中向量加法就是按位异或。

题目给出 $n$ 个集合 $S_1,S_2,\ldots,S_n\subseteq E$。一次操作选择一个向量 $x$，并把 $x$ 同时加入所有集合。我们要用最少的操作，使每个集合都对异或封闭。

非空集合对异或封闭，当且仅当它是 $\mathbb F_2$ 上的线性子空间。因此，问题等价于：求一个最小的公共添加集合 $T$，使得

$$
S_i\cup T
$$

对所有 $i$ 都是线性子空间。

下文始终把 $S_i$ 视为最初输入的集合，不直接修改它。算法动态维护的是“已经确定必须加入的方向”。

---

## 2. 维护答案所张成的空间

设当前已经找到的向量张成

$$
W=\operatorname{span}(G),
$$

其中 $G$ 是 $W$ 的异或线性基。这里的 $W$ 不是最终要逐个输出的操作集合，而是这些操作张成的空间。

对固定的 $W$，定义映射

$$
f:E\to E
$$

如下：把 $x$ 放入 $G$ 中，从高位到低位依次消元，最后无法继续消去的余数就是 $f(x)$。

如果 $G_j$ 表示最高位为 $j$ 的基向量，那么过程就是：从高位到低位扫描 $j$，当 $x_j=1$ 且 $G_j\ne 0$ 时令 $x\gets x\oplus G_j$。

这个 $f$ 可以看成模掉子空间 $W$ 后，为每个商空间陪集选取一个规范代表的线性投影。它满足

$$
f(x)=0\iff x\in W,
\qquad
x\oplus f(x)\in W.
$$

---

## 3. 核心观察一：消元余数映射是线性的

最关键的性质是

$$
\boxed{f(x\oplus y)=f(x)\oplus f(y)}.
$$

记处理第 $j$ 个基向量的单步变换为

$$
L_j(z)=z\oplus z_jG_j,
$$

其中 $z_j\in\mathbb F_2$ 是 $z$ 的第 $j$ 位。

由于“取第 $j$ 位”是线性函数，所以

$$
\begin{aligned}
L_j(x\oplus y)
&=(x\oplus y)\oplus (x_j\oplus y_j)G_j\\
&=(x\oplus x_jG_j)\oplus(y\oplus y_jG_j)\\
&=L_j(x)\oplus L_j(y).
\end{aligned}
$$

每一步 $L_j$ 都是线性映射，而 $f$ 是这些线性映射的复合，因此 $f$ 也是线性映射。

这个结论不要求线性基是行最简形式，只要求每个非空基向量拥有不同的最高位，并按固定的从高到低顺序消元。

因此，对任意集合 $A$，都有

$$
f(\operatorname{span}(A))
=\operatorname{span}(f(A)).
$$

这使我们不必枚举一个集合的整个张成空间，只需对原集合中的元素做投影，再维护这些投影的线性基。

---

## 4. 投影后的空间与等大纤维

对每个 $i$，定义当前必须考虑的空间

$$
V_i=\operatorname{span}(S_i\cup W).
$$

再定义它在投影下的像空间

$$
R_i=f(V_i).
$$

因为 $f(W)=0$，结合 $f$ 的线性性可得

$$
R_i=f(\operatorname{span}(S_i)),
$$

所以只需要维护一组线性基 $C_i$，满足

$$
\operatorname{span}(C_i)=R_i.
$$

考察限制映射

$$
f|_{V_i}:V_i\to R_i.
$$

由于 $W\subseteq V_i$ 且 $\ker f=W$，所以

$$
\ker(f|_{V_i})=W.
$$

于是，对于任意 $u\in R_i$，原像集合

$$
F_{i,u}=\{x\in V_i:f(x)=u\}
$$

都是 $W$ 的一个陪集，大小完全相同：

$$
|F_{i,u}|=|W|=2^{\dim W}.
$$

记这个统一的大小为

$$
K=2^{\dim W}.
$$

如果另外维护 $V_i$ 的基 $B_i$，由秩—零化度定理也可以写成

$$
K=2^{\dim B_i-\dim C_i}.
$$

但对所有 $i$ 都有

$$
\dim B_i-\dim C_i=\dim W,
$$

所以 $K$ 直接由全局基 $G$ 的维数得到即可，根本不需要维护 $B_i$。

---

## 5. 什么时候需要向 $W$ 加入新方向

对原集合中的每个 $x\in S_i$，维护它当前的余数 $f(x)$。开桶统计

$$
\operatorname{cnt}_i[u]
=|\{x\in S_i:f(x)=u\}|.
$$

因为 $S_i\subseteq V_i$，所以这个数正是 $S_i$ 已经占据纤维 $F_{i,u}$ 的元素数。

若某个非零 $u\in R_i$ 满足

$$
\operatorname{cnt}_i[u]<K,
$$

那么大小为 $K$ 的纤维 $F_{i,u}$ 没有被 $S_i$ 填满。也就是说，存在

$$
y\in V_i\setminus S_i,
\qquad f(y)=u.
$$

此时把 $u$ 加入全局基 $G$，即令

$$
W\gets W+\operatorname{span}\{u\}.
$$

这里只检查 $u\ne 0$。零纤维就是 $W$ 本身，其中缺失的元素可以在算法结束后直接作为操作输出，不需要再产生新的线性方向。

### 为什么加入的是余数 $u$，而不是缺失元素 $y$

因为 $f(y)=u$ 意味着

$$
y\oplus u\in W.
$$

一旦已经拥有整个方向空间 $W$，加入 $y$ 与加入 $u$ 对扩张张成空间的效果完全相同：

$$
\operatorname{span}(W\cup\{y\})
=\operatorname{span}(W\cup\{u\}).
$$

而 $u$ 已经关于当前基消元完毕，特别适合直接插入 $G$ 并进行后续动态更新。

---

## 6. 如何快速找到这样的 $u$

对固定的 $i$，先遍历所有保存的 $f(x)$，建立计数桶。

### 6.1 候选值已经出现过

再次遍历 $x\in S_i$。如果某个非零 $f(x)$ 满足

$$
\operatorname{cnt}_i[f(x)]<K,
$$

直接取 $u=f(x)$。

### 6.2 候选值没有出现过

若上述情况不存在，还可能有某个非零

$$
u\in R_i=\operatorname{span}(C_i)
$$

从未在这些 $f(x)$ 中出现。此时 $\operatorname{cnt}_i[u]=0<K$，同样可以使用。

设 $r_i=\dim R_i$。我们只需从 $R_i$ 中生成

$$
q=\min(2^{r_i}-1,\ |S_i|+1)
$$

个互不相同的非零向量：

- 如果 $2^{r_i}-1\le |S_i|+1$，我们已经枚举了 $R_i$ 的全部非零元素；
- 否则，我们生成了 $|S_i|+1$ 个不同的非零向量，而 $S_i$ 至多贡献 $|S_i|$ 个不同余数。由鸽巢原理，其中至少一个没有出现。

用 $C_i$ 的基向量按 Gray Code 枚举，可以让相邻两个向量只相差一个基向量，因此每产生一个候选只需 $O(1)$ 次异或。

统一到代码里，可以令

$$
\text{lim}=\min(2^{r_i},\ |S_i|+2),
$$

再枚举 Gray Code 编号 $1,2,\ldots,\text{lim}-1$。编号 $0$ 对应零向量，恰好被跳过。

---

## 7. 核心观察二：加入新方向后，整个投影如何变化

设当前找到的非零余数为 $u$，其最高位为

$$
p=\operatorname{msb}(u).
$$

因为 $u=f_{\mathrm{old}}(u)$，当前全局基已有的所有主元位在 $u$ 中都为零。因此 $p$ 一定是一个新的主元位，插入后 $\dim W$ 增加一。

定义线性映射

$$
L_u(z)=z\oplus z_pu.
$$

也就是：若 $z$ 的第 $p$ 位为 $1$，就异或一次 $u$；否则保持不变。

加入 $u$ 后的新投影满足第二个核心公式：

$$
\boxed{f_{\mathrm{new}}=L_u\circ f_{\mathrm{old}}}.
$$

亦即

$$
f_{\mathrm{new}}(x)
=f_{\mathrm{old}}(x)
\oplus (f_{\mathrm{old}}(x))_p u.
$$

直观上，$f_{\mathrm{old}}(x)$ 已经消掉所有旧主元；加入的新主元只有 $p$，所以只需再判断余数的第 $p$ 位是否为 $1$。

在线性基实现中，为保持阶梯形，我们可能还会用 $u$ 消去旧基向量的第 $p$ 位。这不会破坏公式：那些调整只是在同一个空间 $W+\operatorname{span}\{u\}$ 中更换基向量表示，而最终规范余数恰好仍是 $L_u(f_{\mathrm{old}}(x))$。

这个观察带来两个直接优化。

### 7.1 更新所有原集合元素的余数

对每个当前保存的 $z=f_{\mathrm{old}}(x)$，执行

```cpp
if ((z >> p) & 1) z ^= u;
```

即可得到 $f_{\mathrm{new}}(x)$。不需要重新把原始 $x$ 放进全局基里消元。

### 7.2 更新每个像空间的基 $C_i$

因为 $L_u$ 是线性的，

$$
R_i^{\mathrm{new}}
=f_{\mathrm{new}}(V_i+\operatorname{span}\{u\})
=L_u(R_i^{\mathrm{old}}).
$$

所以只需把 $L_u$ 作用到 $C_i$ 的每个基向量上，再维护成阶梯形。

若 $C_i[j]$ 的最高位是 $j$，更新规则为：

1. 对 $j>p$，若 $C_i[j]$ 的第 $p$ 位为 $1$，令 $C_i[j]\mathrel{\hat{=}}u$。其最高位仍是 $j$。
2. 对 $j<p$，它不可能含有第 $p$ 位，不变。
3. 若 $C_i[p]\ne0$，则 $L_u(C_i[p])=C_i[p]\oplus u$ 的最高位已经低于 $p$。先清空原槽，再把这个新向量重新插入 $C_i$。它也可能直接变成零。

这一过程只需 $O(m)$，不必重新扫描整个 $S_i$ 来建立 $C_i$。

---

## 8. 完整算法

记 $G$ 为全局基，$W=\operatorname{span}(G)$。对每个 $i$，维护：

- 数组 `rem[i]`：原集合 $S_i$ 中每个元素当前的 $f(x)$；
- 线性基 $C_i$：张成 $f(\operatorname{span}(S_i))$。

初始时 $W=\{0\}$，$G$ 为空，$f$ 是恒等映射，所以 `rem[i]` 就是原元素本身，$C_i$ 就是 $S_i$ 的线性基。

不断执行：

1. 令 $K=2^{\dim W}=2^{\dim G}$。
2. 依次处理每个 $i$：
   - 统计所有 `rem[i]` 的出现次数；
   - 检查已出现的非零余数是否有计数小于 $K$；
   - 若没有，则在 $\operatorname{span}(C_i)$ 中用 Gray Code 生成至多 $|S_i|+1$ 个非零候选，寻找计数小于 $K$ 的候选。
3. 如果所有 $i$ 都找不到候选，算法结束。
4. 否则得到非零 $u$，令 $p=\operatorname{msb}(u)$：
   - 把 $u$ 插入全局基 $G$；
   - 对每个 $i$，用 $L_u$ 更新 $C_i$；
   - 对每个保存的余数 $z$，若第 $p$ 位为 $1$，令 $z\mathrel{\hat{=}}u$。

每次成功找到 $u$，全局空间 $W$ 的维数都增加一，所以循环至多进行 $m$ 次。

---

## 9. 正确性证明

### 引理 1：算法维护的 $f$ 是线性映射，且 $\ker f=W$

前文已经证明，每个单步消元都是线性映射，它们的复合 $f$ 仍然线性。一个向量被完全消为零，当且仅当它属于全局基所张成的空间，所以 $\ker f=W$。

### 引理 2：候选判据恰好能发现未填满的非零纤维

对任意 $u\in R_i$，纤维 $F_{i,u}$ 是 $W$ 的陪集，大小为 $K=2^{\dim W}$。而 $\operatorname{cnt}_i[u]$ 是其中已经属于原集合 $S_i$ 的元素数。因此

$$
\operatorname{cnt}_i[u]<K
$$

当且仅当该纤维中存在某个 $V_i\setminus S_i$ 的元素。

对已出现余数的扫描和对至多 $|S_i|+1$ 个不同余数的 Gray Code 枚举，保证只要存在未填满的非零纤维，就能找到一个合法的 $u$。

### 引理 3：算法加入的每一个方向都是任何可行答案所必需的

取任意可行操作集合 $T^*$，令

$$
W^*=\operatorname{span}(T^*).
$$

证明算法始终保持

$$
W\subseteq W^*.
$$

初始时显然成立。假设当前成立，算法因某个未填满纤维选择了 $u$。于是存在

$$
y\in V_i\setminus S_i,
\qquad f(y)=u.
$$

由于 $V_i=\operatorname{span}(S_i\cup W)$ 且 $W\subseteq W^*$，而可行集合 $S_i\cup T^*$ 是同时包含 $S_i$ 与 $W^*$ 的子空间，所以 $y\in S_i\cup T^*$。又因为 $y\notin S_i$，只能有 $y\in T^*\subseteq W^*$。

另一方面，$y\oplus u\in W\subseteq W^*$，所以

$$
u=y\oplus(y\oplus u)\in W^*.
$$

加入 $u$ 后仍有 $W\subseteq W^*$，归纳完成。

### 引理 4：停止时构造出的答案可行

令

$$
J=\bigcap_{i=1}^n S_i,
\qquad
T=W\setminus J.
$$

也就是说，枚举 $W$ 中的全部向量；已经在所有原集合中出现的向量不必操作，其余向量各操作一次。

算法停止意味着，对每个 $i$，所有非零纤维都已经被 $S_i$ 填满。任取 $z\in V_i$：

- 若 $f(z)\ne0$，则 $z$ 属于某个已填满的非零纤维，因此 $z\in S_i$；
- 若 $f(z)=0$，则 $z\in W$。若 $z\in S_i$ 已经满足；否则 $z\notin J$，故 $z\in T$。

所以 $V_i\subseteq S_i\cup T$。反过来，$S_i\subseteq V_i$ 且 $T\subseteq W\subseteq V_i$，于是

$$
S_i\cup T=V_i.
$$

$V_i$ 是线性子空间，因此所有集合最终都对异或封闭。

### 引理 5：构造出的答案操作数最少

仍取任意可行答案 $T^*$。由引理 3，算法最终的 $W$ 满足

$$
W\subseteq W^*.
$$

任取 $w\in T=W\setminus J$。因为 $w\notin J$，至少存在一个 $i$ 使 $w\notin S_i$。又因为 $w\in W\subseteq W^*$，而可行的子空间 $S_i\cup T^*$ 必须包含 $W^*$，所以 $w\in S_i\cup T^*$。结合 $w\notin S_i$，得到 $w\in T^*$。

因此

$$
T\subseteq T^*
$$

对任意可行答案都成立。特别地，$|T|\le |T^*|$，所以算法输出的是最优答案。

---

## 10. 如何输出答案

读入时维护

$$
\operatorname{occur}[x]
=|\{i:x\in S_i\}|.
$$

算法结束后用 Gray Code 枚举 $W=\operatorname{span}(G)$ 的所有元素 $x$。若

$$
\operatorname{occur}[x]<n,
$$

说明 $x$ 并非一开始就在所有集合中，应当输出一次操作 $x$。

特别注意：必须枚举 $W$ 中的零向量。若 $0$ 没有在所有原集合中出现，也必须执行加入 $0$ 的操作。最终枚举不能从第一个非零组合开始。

---

## 11. 复杂度

记

$$
C=\sum_{i=1}^n|S_i|.
$$

- 初始化所有 $C_i$：$O(Cm)$；
- 全局基最多扩张 $m$ 次；
- 每次寻找候选、更新所有余数：$O(C)$；
- 每次更新全部 $C_i$：$O(nm)$；
- Gray Code 预处理与最终枚举答案：$O(2^m)$。

总时间复杂度为

$$
\boxed{O(Cm+nm^2+2^m)}.
$$

空间复杂度为

$$
\boxed{O(C+nm+2^m)}.
$$

---

## 12. 参考实现

下面的实现保留了上述做法的直接结构。代码中的 `G` 是全局答案空间 $W$ 的基，`C[i]` 是投影像空间 $R_i$ 的基，而 `s[i]` 存放的已经不是原值，而是每个原值当前的 $f(x)$。原集合信息另由 `occur` 保留，用于最终输出。

```cpp
#include <bits/stdc++.h>
#define VI vector<int>
using namespace std;

inline int read(){
    int x=0,f=1;char ch=getchar();
    for(;!isdigit(ch);ch=getchar())f^=ch=='-';
    for(;isdigit(ch);ch=getchar())x=x*10+(ch^48);
    return f?x:-x;
}

namespace gray_code{
    void work(int n,VI &ret){
        ret.resize(1<<n);
        for(int i=0;i<(int)ret.size();++i)ret[i]=i^(i>>1);
    }
}

struct Linear_Basis{
    int m;
    VI B;
    Linear_Basis(int n=0):m(n-1),B(VI(n,0)){}
    int proj(int x){
        for(int i=m;~i;--i){
            if(B[i]&&((x>>i)&1))x^=B[i];
        }
        return x;
    }
    void insert(int x){
        if(!(x=proj(x)))return;
        for(int i=m;~i;--i)if((x>>i)&1){
            B[i]=x;
            for(int j=m;j>i;--j){
                if((B[j]>>i)&1)B[j]^=x;
            }
            break;
        }
    }
    int dim(){
        int ret=0;
        for(int i=m;~i;--i)ret+=B[i]!=0;
        return ret;
    }
    void resort(VI &ret){
        ret={};
        for(int i=m;~i;--i){
            if(B[i])ret.push_back(B[i]);
        }
    }
    // 把线性映射 z -> z ^ z_h*x 作用到整组基上
    void restrict(int x,int h){
        for(int i=m;i>h;--i){
            if(B[i]&&((B[i]>>h)&1))B[i]^=x;
        }
        if(B[h]){
            int tmp=B[h]^x;
            B[h]=0;
            insert(tmp);
        }
    }
};

int n,m;
VI occur,gray,lg;
vector<VI> s;
vector<Linear_Basis> C;

void solve(){
    s.assign(n=read(),{}),m=read();
    Linear_Basis G(m),I(m);
    C=vector<Linear_Basis>(n,I);
    occur.assign(1<<m,0);
    gray_code::work(m,gray);
    lg.assign(1<<m,-1);
    for(int i=1;i<(int)lg.size();++i)lg[i]=lg[i>>1]+1;

    for(int i=0;i<n;++i){
        int c=read();
        while(c--){
            int x=read();
            ++occur[x];
            s[i].push_back(x);
            C[i].insert(x);
        }
    }

    VI cnt(1<<m,0);
    while(1){
        int FIND=0;
        int k=1<<G.dim();
        for(int i=0;i<n;++i){
            for(int x:s[i])++cnt[x];

            // 先检查已经出现过、但所在纤维没有填满的非零余数
            for(int x:s[i])if(x&&cnt[x]<k){
                FIND=x;
                break;
            }

            // 再检查像空间中没有出现过的余数
            if(!FIND){
                int lim=min(1<<C[i].dim(),(int)s[i].size()+2);
                VI tmp;
                C[i].resort(tmp);
                for(int j=1,val=0;j<lim;++j){
                    int bit=lg[gray[j]^gray[j-1]];
                    val^=tmp[bit];
                    if(cnt[val]<k){
                        FIND=val;
                        break;
                    }
                }
            }

            for(int x:s[i])cnt[x]=0;
            if(FIND)break;
        }

        if(!FIND)break;
        G.insert(FIND);

        int highbit=0;
        for(int i=m-1;~i;--i){
            if((FIND>>i)&1){
                highbit=i;
                break;
            }
        }

        for(int i=0;i<n;++i){
            C[i].restrict(FIND,highbit);
            for(int &x:s[i]){
                if((x>>highbit)&1)x^=FIND;
            }
        }
    }

    VI tmp,ans={};
    G.resort(tmp);
    int ss=1<<(int)tmp.size();
    for(int i=0,val=0;i<ss;++i){
        if(i){
            int bit=lg[gray[i]^gray[i-1]];
            val^=tmp[bit];
        }
        if(occur[val]!=n)ans.push_back(val);
    }

    printf("%d\n",(int)ans.size());
    for(int x:ans)printf("%d ",x);
    puts("");
}

signed main(){
    solve();
}
```

---

## 13. 两个观察如何串起整套算法

整套做法真正的核心可以压缩成两句话：

1. **固定当前全局基时，消元余数是线性的：**

$$
   f(x\oplus y)=f(x)\oplus f(y).
$$

   因此可以只维护 $f(S_i)$ 的线性基，并用核与像分析每个等大的纤维，而不必枚举 $\operatorname{span}(S_i)$。

2. **向全局基加入一个已经消元完毕的新方向 $u$ 后：**

$$
   f_{\mathrm{new}}=L_u\circ f_{\mathrm{old}},
   \qquad
   L_u(z)=z\oplus z_pu.
$$

   因此所有元素余数和所有像空间线性基都能增量更新，而不必从头重新消元。

第一个观察把指数规模的张成空间压缩成“像空间基 + 纤维计数”；第二个观察又把每轮重建压缩成一次线性扫描。二者共同得到最终的

$$
O(Cm+nm^2+2^m)
$$

算法。
