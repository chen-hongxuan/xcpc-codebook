namespace tarjan{
    int work(int n,vector<VI> &edge,vector<VI> &scc){
        int dfntot=0;
        vector<int> dfn,low;
        stack<int> sta;
        dfn=low=VI(n+3,0),scc={};
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
        return scc.size();
    }
}