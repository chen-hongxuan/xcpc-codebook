//f[u][k]: u到距离为k的后代的最大路径点权和
LongChain dp;
dp.init(edge);
VI L(n+1,0),R(n+1),d(n+1),ans(n+1);
for(int u:dp.ord){
  R[u]=dp.h[u]-1,d[u]=(dp.son[u]!=0);
}
dp.build(L,R,d);
for(int i=n-1;i>=0;--i){
  int u=dp.ord[i];
  dp.inherit(u),dp.shift(u,d[u]);
  dp.add(u,a[u]),dp.change(u,0,a[u]);
  for(int v:edge[u]){
    if(v==dp.fa[u]||v==dp.son[u])continue;
    for(int k=0;k<dp.h[v];++k)
      dp.change(u,k+1,dp.query(v,k,k)+a[u]);
  }
  ans[u]=dp.query(u,A[u],B[u]);
}
