namespace MillerRabin{
  int test(int n){
    if(n<3||n%2==0)return n==2;
    if(n%3==0)return n==3;
    int u=n-1,t=0;
    while(u%2==0)u>>=1,++t;
    VI ut{2,325,9375,28178,450775,9780504,1795265022};
    auto qpow=[&](int x,int t){
      int ret=1;
      for(;t;t>>=1,x=x*x%n)if(t&1)ret=ret*x%n;
      return ret;
    };
    for(int a:ut){
      int v=qpow(a,u),s;
      if(v==1)continue;
      for(s=0;s<t;++s,v=v*v%n)if(v==n-1)break;
      if(s==t)return 0;
    }
    return 1;
  }
}