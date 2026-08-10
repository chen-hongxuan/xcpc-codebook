namespace tarjan{
    int work(int n,vector<VI> &edge,VI &color){
        int dfntot=0,coltot=0;
        vector<int> dfn,low,vis;
        stack<int> sta;
        color=dfn=low=vis=VI(n+3,0);
        function<void(int)> dfs=[&](int u){
            dfn[u]=low[u]=++dfntot;
            sta.push(u),vis[u]=1;
            for(int v:edge[u]){
                if(!dfn[v]){
                    dfs(v);
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
            dfs(i);
        }
        return coltot;
    }
}