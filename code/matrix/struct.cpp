struct matrix{
  static constexpr int mo=_P_;
  vector<VI> a;
  int n=0,m=0;

  static inline void red(int &x){if(x>=mo)x-=mo;}
  static inline int qpow(int x,int t=mo-2){
    int ret=1;
    for(;t;t>>=1,x=x*x%mo)if(t&1)ret=ret*x%mo;
    return ret;
  }

  matrix()=default;
  matrix(int _n,int _m,int v=0):n(_n),m(_m){
    v%=mo;
    if(v<0)v+=mo;
    a.assign(n,VI(m,v));
  }
  matrix(int _n):matrix(_n,_n){
    for(int i=0;i<n;++i)a[i][i]=1;
  }

  VI &operator[](size_t i){return a[i];}
  const VI &operator[](size_t i)const{return a[i];}

  //剩余功能在以下的空间内实现

}mat;