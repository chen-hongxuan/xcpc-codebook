struct Lagrange{
    static constexpr int mo=_P_;
    inline void red(int &x){if(x>=mo)x-=mo;}
    inline int qpow(int x,int t=mo-2){
        int ret=1;
        for(;t;t>>=1,x=x*x%mo)if(t&1)ret=ret*x%mo;
        return ret;
    }
    vector<array<int,3>> node;
    Lagrange():node({}){}
    int insert(int x,int y){
        for(auto [rx,ry,p]:node){
            if(x==rx)return y==ry?0:-1;
        }
        int M=1;
        for(auto &[rx,ry,p]:node){
            p=p*(rx+mo-x)%mo;
            M=M*(x+mo-rx)%mo;
        }
        node.push_back({x,y,M});
        return 1;
    }
    int find(int u){
        int sum=1,ret=0;
        for(auto [x,y,p]:node){
            if(x==u)return y;
            sum=sum*(u+mo-x)%mo;
        }
        for(auto [x,y,p]:node){
            int tmp=qpow(p*(u+mo-x)%mo);
            red(ret+=y*sum%mo*tmp%mo);
        }
        return ret;
    }
    void fast_construct(int l,VI &y){
        node.resize(y.size());
        VI fac(y.size(),1);
        for(int i=1;i<y.size();++i){
            fac[i]=fac[i-1]*i%mo;
        }
        for(int i=0;i<y.size();++i){
            node[i][0]=l+i,node[i][1]=y[i];
            node[i][2]=fac[i]*fac[y.size()-1-i]%mo;
            if((y.size()-1-i)&1){
                red(node[i][2]=mo-node[i][2]);
            }
        }
    }
};