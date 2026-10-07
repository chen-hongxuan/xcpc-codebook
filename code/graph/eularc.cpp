namespace EularGraph{
  VI Hierholzer(int n,vector<VII> &edge){//无自环
    VI last(n+1,0),stk;
    vector<VI> vis(n+1);
    for(int i=1;i<=n;++i){
      vis[i].assign(edge[i].size(),0);
    }
    auto dfs=[&](int u,auto &&self)->void{
      for(int &i=last[u];i<edge[u].size();++i){
        if(vis[u][i])continue;
        auto [v,j]=edge[u][i];
        vis[u][i]=vis[v][j]=1;
        self(v,self);
      }
      stk.push_back(u);
    };
    int root=n;
    for(int i=1,m=0;i<=n;++i){
      if(edge[i].size()&1){
        if(++m>2)return {-1};
        root=i;
      }
    }
    dfs(root,dfs);
    reverse(stk.begin(),stk.end());
    return stk;
  }
  vector<VI> ex_Hierholzer(int n,vector<VII> &edge){
    vector<VII> E=edge;
    E.push_back({});
    int odddeg=0;
    for(int i=1,k=n+1;i<=n;++i){
      if(E[i].size()&1){
        int ii=E[i].size(),ik=E[k].size();
        E[i].push_back({k,ik});
        E[k].push_back({i,ii});
        odddeg=1;
      }
    }
    VI path=Hierholzer(n+odddeg,E),tmp={};
    vector<VI> ret;
    for(int x:path){
      if(x==n+1){
        if(tmp.size()){
          ret.push_back(tmp);
          tmp={};
        }
      }else tmp.push_back(x);
    }
    if(tmp.size())ret.push_back(tmp);
    return ret;
  }
}
