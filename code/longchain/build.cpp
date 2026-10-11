void plan(const VI &L,const VI &R,const VI &d){
  int n=ord.size();
  VI l=L,r=R,o(n+1);
  for(int i=n-1;i>=0;--i){
    int u=ord[i],v=son[u];
    o[u]=d[u]+(v?o[v]:0);
    l[u]-=o[u],r[u]-=o[u];
    if(v)chmin(l[u],l[v]),chmax(r[u],r[v]);
  }
  c.resize(head.size());
  for(int u:head)c[bel[u]]={l[u],r[u]-l[u]+1};
  off.assign(n+1,0);
}
