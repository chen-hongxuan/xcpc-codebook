void init(const vector<VI> &edge,int root=1){
  int n=edge.size()-1;
  fa.assign(n+1,0),h.assign(n+1,1);
  son.assign(n+1,0),bel.assign(n+1,0);
  off.assign(n+1,0);
  c.clear(),tr.clear(),ord.clear();
  ord.reserve(n),ord.push_back(root);
  for(int i=0;i<n;++i){
    int u=ord[i];
    for(int v:edge[u]){
      if(v==fa[u])continue;
      fa[v]=u,ord.push_back(v);
    }
  }
  for(int i=n-1;i>=0;--i){
    int u=ord[i];
    for(int v:edge[u]){
      if(v!=fa[u]&&h[v]+1>h[u])
        h[u]=h[v]+1,son[u]=v;
    }
  }
}
