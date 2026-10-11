//使用普通线段树的建树、单点加、区间和模块
LongChain lc;
lc.init(edge);
VI L(n+1,0),R(n+1),d(n+1),ans(n+1);
for(int u:lc.ord){
  R[u]=lc.h[u]-1,d[u]=(lc.son[u]!=0);
}
lc.plan(L,R,d);
SegmentTree seg;
vector<signed> rt(lc.head.size());
for(int id=0;id<rt.size();++id){
  int r=lc.c[id].w-1;
  rt[id]=seg.newnode(0,r);
  seg.build(rt[id],0,r);
}
for(int i=n-1;i>=0;--i){
  int u=lc.ord[i],id=lc.bel[u];
  lc.inherit(u),lc.shift(u,d[u]);
  seg.modify(rt[id],lc.pos(u,0),1);
  for(int v:edge[u]){
    if(v==lc.fa[u]||v==lc.son[u])continue;
    for(int k=0;k<lc.h[v];++k){
      int p=lc.pos(v,k);
      int cnt=seg.query(rt[lc.bel[v]],p,p);
      seg.modify(rt[id],lc.pos(u,k+1),cnt);
    }
  }
  auto [l,r]=lc.range(u,A[u],B[u]);
  ans[u]=l<=r?seg.query(rt[id],l,r):0;
}
