namespace dijkstra{
  void work(int n,VI &s,vector<vector<array<int,2>>> &edge,VI &dis){
    priority_queue<array<int,2>> q;
    dis.assign(n+5,inf);
    VI vis(n+5,0);
    for(int x:s){
      dis[x]=0;
      q.push({0,x});
    }
    while(q.size()){
      int u=q.top()[1];
      q.pop();
      if(vis[u])continue;
      vis[u]=1;
      for(auto [v,w]:edge[u]){
        if(dis[v]>dis[u]+w){
          dis[v]=dis[u]+w;
          q.push({-dis[v],v});
        }
      }
    }
  }
}