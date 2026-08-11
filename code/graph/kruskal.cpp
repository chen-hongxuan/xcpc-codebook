namespace kruskal{
    vector<array<int,3>> work(int n,vector<array<int,3>> edge){
        vector<array<int,3>> ret={};
        vector<int> f(n+3);
        for(int i=1;i<=n;++i)f[i]=i;
        function<int(int)> find=[&](int x){
            return f[x]==x?x:f[x]=find(f[x]);
        };
        sort(edge.begin(),edge.end(),[](auto x,auto y){
            return x[2]<y[2];
        });
        for(auto [x,y,w]:edge){
            int fx=find(x),fy=find(y);
            if(fx!=fy){
                f[fx]=fy;
                ret.push_back({x,y,w});
            }
        }
        return ret;
    }
}