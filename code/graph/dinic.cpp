struct dinic{
  vector<vector<array<int,3>>> edge;
  VI lv,cur;
  int n,s,t;
  void dinic_init(int a,int b,int c){
    n=a,s=b,t=c;
    edge.assign(n+3,{});
  }
  dinic(int a=0,int b=0,int c=0){
    dinic_init(a,b,c);
  }
  void addedge(int x,int y,int w){
    int ix=edge[x].size(),iy=edge[y].size();
    edge[x].push_back({y,w,iy+(x==y)});
    edge[y].push_back({x,0,ix});
  }
  inline int bfs(){
    lv.assign(n+3,-1);
    cur.assign(n+3,0);
    queue<int> q;
    q.push(s),lv[s]=0;
    while(q.size()){
      int u=q.front();
      q.pop();
      for(auto [v,w,p]:edge[u])if(w){
        if(lv[v]==-1){
          q.push(v);
          lv[v]=lv[u]+1;
        }
      }
    }
    return lv[t]!=-1;
  }
  int dfs(int u,int flow){
    if(u==t)return flow;
    int rst=flow;
    for(int &i=cur[u];i<edge[u].size();++i){
      auto &[v,w,p]=edge[u][i];
      if(lv[v]==lv[u]+1&&w){
        int &iw=edge[v][p][1];
        int c=dfs(v,min(rst,w));
        w-=c,iw+=c,rst-=c;
      }
      if(!rst)break;
    }
    if(rst)lv[u]=-1;
    return flow-rst;
  }
  int solve(){
    int ret=0;
    while(bfs())ret+=dfs(s,inf);
    return ret;
  }
}mf;