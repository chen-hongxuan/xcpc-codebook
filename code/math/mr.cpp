namespace MillerRabin{
  int test(int n){
    if(n<3||n%2==0)return n==2;
    if(n%3==0)return n==3;
    int u=n-1,t=0;
    while(u%2==0)u>>=1,++t;
    auto mul=[&](int x,int y){
      return (int)((__int128)x*y%n);
    };
    auto qpow=[&](int x,int t){
      int ret=1;
      for(;t;t>>=1,x=mul(x,x)){
        if(t&1)ret=mul(ret,x);
      }
      return ret;
    };
    VI ut{2,325,9375,28178,450775,9780504,1795265022};
    for(int a:ut){
      a%=n;
      if(!a)continue;
      int v=qpow(a,u),s;
      if(v==1)continue;
      for(s=0;s<t;++s,v=mul(v,v)){
        if(v==n-1)break;
      }
      if(s==t)return 0;
    }
    return 1;
  }
}