struct poly{
  static const int mo=_MOD_,gn=_G_;
  static inline void red(int &x){if(x>=mo)x-=mo;}
  static inline int qpow(int x,int t=mo-2){
    x=(x%mo+mo)%mo;
    int ret=1;
    for(;t;t>>=1,x=x*x%mo)if(t&1)ret=ret*x%mo;
    return ret;
  }
  VI f;
  poly(int len=0,int val=0):f(VI(len,val)){}
  int size()const{return f.size();}
  void reduct(int siz){f.resize(siz,0);}
  void bas2_extend(int siz){
    int len=1;
    while(len<siz)len<<=1;
    reduct(len);
  }
  int &operator[](size_t x){return f[x];}
  const int &operator[](size_t x)const{return f[x];}

  //剩余功能在以下的空间内实现

};