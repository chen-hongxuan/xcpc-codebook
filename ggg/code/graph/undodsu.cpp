struct DSU{
    VI fa,siz,sta;
    int n;
    DSU(int n=0){dsu_init(n);}
    void dsu_init(int m){
        fa.resize((n=m)+1);
        iota(fa.begin(),fa.end(),0);
        siz.assign(n+1,1);
        sta.clear();
    }
    int newnode(){
        fa.push_back(++n);
        siz.push_back(1);
        return n;
    }
    int find(int x){
        return fa[x]==x?x:find(fa[x]);
    }
    bool merge(int x,int y){
        x=find(x),y=find(y);
        if(x==y)return false;
        if(siz[x]<siz[y])swap(x,y);
        sta.push_back(y);
        fa[y]=x,siz[x]+=siz[y];
        return true;
    }
    bool undo(){
        if(sta.empty())return false;
        int y=sta.back(),x=fa[y];
        sta.pop_back();
        siz[x]-=siz[y],fa[y]=y;
        return true;
    }
}dsu;