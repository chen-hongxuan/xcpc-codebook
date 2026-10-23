namespace Zassenhause{
  LinearBasis work(LinearBasis &a,LinearBasis &b){
    assert(a.m==b.m);
    int n=a.m+1;
    VII p(2*n);
    auto add=[&](int x,int y){
      for(int k=0;k<2;++k){
        int &v=k?y:x;
        for(int i=n-1;~i;--i)if((v>>i)&1){
          auto &z=p[k*n+i];
          if(!z[k]){z={x,y};return;}
          x^=z[0],y^=z[1];
        }
      }
    };
    for(int x:a.B)if(x)add(x,x);
    for(int x:b.B)if(x)add(x,0);
    LinearBasis ret(n);
    for(int i=0;i<n;++i)ret.insert(p[n+i][1]);
    return ret;
  }
}
