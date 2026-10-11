//f[u]倒序存储: 距离k对应f[u].size()-1-k
LongChain lc;
lc.init(edge);
vector<VI> f(n+1);
VI ans(n+1);
for(int i=n-1;i>=0;--i){
  int u=lc.ord[i],s=lc.son[u];
  if(s)f[u].swap(f[s]);
  for(int v:edge[u]){
    if(v==lc.fa[u]||v==s)continue;
    int a=f[u].size(),b=f[v].size();
    for(int k=0;k<b;++k)f[u][a-1-k]+=f[v][b-1-k];
    VI().swap(f[v]);
  }
  f[u].push_back(1);
  ans[u]=K<f[u].size()?f[u][f[u].size()-1-K]:0;
}
