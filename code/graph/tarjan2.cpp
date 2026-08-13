namespace tarjan{
  int work(int n,vector<vector<array<int,2>>> &edge,VI &color){
    int dfntot=0,coltot=0;
    vector<int> dfn,low,vis;
    stack<int> sta;
    color=dfn=low=vis=VI(n+3,0);
    function<void(int,int)> dfs=[&](int u,int id){
      dfn[u]=low[u]=++dfntot;
      sta.push(u),vis[u]=1;
      for(auto [v,e]:edge[u])if(e!=id){
        if(!dfn[v]){
          dfs(v,e);
          chmin(low[u],low[v]);
        }else if(vis[v]){
          chmin(low[u],dfn[v]);
        }
      }
      if(low[u]==dfn[u]){
        ++coltot;
        while(1){
          int x=sta.top();
          sta.pop();
          vis[x]=0;
          color[x]=coltot;
          if(x==u)break;
        }
      }
    };
    for(int i=1;i<=n;++i)if(!dfn[i]){
      dfs(i,-1);
    }
    return coltot;
  }
}