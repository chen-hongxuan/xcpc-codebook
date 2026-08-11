struct ssp{
    vector<vector<array<int,4>>> edge;
    VI lv,cur,vis;
    int n,s,t;
    void ssp_init(int a,int b,int c){
        n=a,s=b,t=c;
        edge.assign(n+3,{});
    }
    ssp(int a=0,int b=0,int c=0){
        ssp_init(a,b,c);
    }
    void addedge(int x,int y,int c,int w){
        int ix=edge[x].size(),iy=edge[y].size();
        edge[x].push_back({y,c,w,iy+(x==y)});
        edge[y].push_back({x,0,-w,ix});
    }
    inline int spfa(){
        lv.assign(n+3,inf);
        cur.assign(n+3,0);
        vis.assign(n+3,0);
        queue<int> q;
        q.push(s),lv[s]=0;
        while(q.size()){
            int u=q.front();
            q.pop(),vis[u]=0;
            for(auto [v,c,w,p]:edge[u])if(c){
                if(lv[v]>lv[u]+w){
                    lv[v]=lv[u]+w;
                    if(!vis[v]){
                        q.push(v);
                        vis[v]=1;
                    }
                }
            }
        }
        return lv[t];
    }
    int dfs(int u,int flow){
        if(u==t)return flow;
        int rst=flow;
        vis[u]=1;
        for(int &i=cur[u];i<edge[u].size();++i){
            auto &[v,cap,w,p]=edge[u][i];
            if(!vis[v]&&cap&&lv[v]==lv[u]+w){
                int &icap=edge[v][p][1];
                int c=dfs(v,min(rst,cap));
                cap-=c,icap+=c,rst-=c;
            }
            if(!rst)break;
        }
        vis[u]=0;
        if(rst)lv[u]=inf;
        return flow-rst;
    }
    array<int,2> solve(){
        array<int,2> ret={0,0};
        int cost=0;
        while((cost=spfa())!=inf){
            int f=dfs(s,inf);
            ret[0]+=f,ret[1]+=f*cost;
        }
        return ret;
    }
}mcmf;