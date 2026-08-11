struct matrix{
    static constexpr int mo=_P_;
    inline void red(int &x){if(x>=mo)x-=mo;}
    inline int qpow(int x,int t=mo-2){
        int ret=1;
        for(;t;t>>=1,x=x*x%mo)if(t&1)ret=ret*x%mo;
        return ret;
    }
    vector<VI> a;
    matrix():a({{}}){}
    matrix(int n,int m,int v=0){
        a.assign(n,VI(m,v));
    }
    matrix(int n){
        a.assign(n,VI(n,0));
        for(int i=0;i<n;++i)a[i][i]=1;
    }
    int n(){return a.size();};
    int m(){return a.back().size();};
    VI &operator[](size_t i){return a[i];}
    matrix operator*(matrix &t){
        if(m()!=t.n())return matrix();
        matrix ret(n(),t.m());
        for(int i=0;i<n();++i)for(int j=0;j<t.m();++j){
            for(int k=0;k<m();++k){
                red(ret[i][j]+=a[i][k]*t[k][j]%mo);
            }
        }
        return ret;
    }
    matrix operator+(matrix t){
        if(n()!=t.n()||m()!=t.m())return matrix();
        for(int i=0;i<n();++i)for(int j=0;j<m();++j){
            red(t[i][j]+=a[i][j]);
        }
        return t;
    }
    matrix operator-(matrix t){
        if(n()!=t.n()||m()!=t.m())return matrix();
        for(int i=0;i<n();++i)for(int j=0;j<m();++j){
            red(t[i][j]=a[i][j]+mo-t[i][j]);
        }
        return t;
    }
    matrix fpow(int t){
        if(n()!=m())return matrix();
        matrix ret=matrix(n()),x=*this;
        for(;t;t>>=1,x=x*x)if(t&1)ret=ret*x;
        return ret;
    }
    matrix gauss(int opt=0){
        matrix r=*this;
        VI vis(n()+1,1);
        for(int i=0;i<n();++i){
            for(int j=0;j<n();++j)if(vis[j]){
                if(r[j][i]!=0){
                    if(i!=j){
                        vis.back()^=1;
                        swap(r[i],r[j]);
                    }
                    break;
                }
            }
            if(!r[i][i])continue;
            int ia=qpow(r[i][i]);
            for(int j=0;j<n();++j){
                if(!r[j][i]||j==i)continue;
                int b=r[j][i]*ia%mo;
                for(int k=i;k<m();++k){
                    red(r[j][k]+=mo-r[i][k]*b%mo);
                }
            }
            vis[i]=0;
        }
        if(opt&&!vis.back())r[0][0]=mo-r[0][0];
        return r;
    }
    int det(){
        if(n()!=m())return -1;
        matrix tmp=gauss(1);
        int ret=1;
        for(int i=0;i<n();++i){
            ret=ret*tmp[i][i]%mo;
        }
        return ret;
    }
    matrix inv(){
        if(n()!=m())return matrix();
        matrix tmp(n(),n()<<1),ret(n(),n());
        for(int i=0;i<n();++i){
            for(int j=0;j<n();++j){
                tmp[i][j]=a[i][j];
            }
            tmp[i][i+n()]=1;
        }
        tmp=tmp.gauss();
        for(int i=0;i<n();++i){
            if(!tmp[i][i]){
                return matrix();
            }
        }
        for(int i=0;i<n();++i){
            int b=qpow(tmp[i][i]);
            for(int j=0;j<n();++j){
                ret[i][j]=tmp[i][j+n()]*b%mo;
            }
        }
        return ret;
    }
}mat;