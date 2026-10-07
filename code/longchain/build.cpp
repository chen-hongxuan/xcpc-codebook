void build(const VI &L,const VI &R,const VI &d){
  int n=ord.size(),tot=0;
  VI l=L,r=R,o(n+1);
  for(int i=n-1;i>=0;--i){
    int u=ord[i],v=son[u];
    o[u]=d[u]+(v?o[v]:0);
    l[u]-=o[u],r[u]-=o[u];
    if(v)chmin(l[u],l[v]),chmax(r[u],r[v]);
  }
  c.clear();
  for(int u:ord){
    if(fa[u]&&son[fa[u]]==u){
      bel[u]=bel[fa[u]];
      continue;
    }
    int w=r[u]-l[u]+1,s=1;
    while(s<w)s<<=1;
    bel[u]=c.size();
    c.push_back({tot,s,l[u],w});
    tot+=s<<1;
  }
  tr.assign(tot,node());
  fill(off.begin(),off.end(),0);
}
