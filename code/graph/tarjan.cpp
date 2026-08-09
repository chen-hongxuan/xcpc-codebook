namespace SCC{
    // 有向圖強連通分量
    int tarjan1(int n,vector<VI> &edge,VI &color){
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
    // 邊雙連通分量
    int tarjan2(int n,vector<vector<array<int,2>>> &edge,VI &color){
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
    // 點雙連通分量
    int tarjan3(int n,vector<VI> &edge,vector<VI> &scc){
        int dfntot=0,scccnt=0;
        vector<int> dfn,low;
        stack<int> sta;
        dfn=low=VI(n+3,0);
        function<void(int,int)> dfs=[&](int u,int fa){
            low[u]=dfn[u]=++dfntot;
            sta.push(u);
            for(int v:edge[u])if(v!=fa){
                if(!dfn[v]){
                    dfs(v,u);
                    if(low[v]>=dfn[u]){
                        VI tmp={};
                        while(1){
                            int x=sta.top();
                            sta.pop();
                            tmp.push_back(x);
                            if(x==v)break;
                        }
                        tmp.push_back(u);
                        scc.push_back(tmp);
                    }else{
                        chmin(low[u],low[v]);    
                    }
                }else{
                    chmin(low[u],dfn[v]);
                }
            }
        };
        for(int i=1;i<=n;++i)if(!dfn[i]){
            if(edge[i].empty()){
                scc.push_back({i});
            }
            dfs(i,-1);
            while(sta.size())sta.pop();
        }
    }
}