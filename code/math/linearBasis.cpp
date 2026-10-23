struct LinearBasis{
  int m;
  VI B;

  int &operator[](size_t i){return B[i];}

  LinearBasis(int n=0):m(n-1),B(VI(n,0)){}

  int proj(int x){
    for(int i=m;~i;--i){
      if(B[i]&&((x>>i)&1))x^=B[i];
    }
    return x;
  }

  int proj_max(int x){
    for(int i=m;~i;--i){
      if(B[i]&&!((x>>i)&1))x^=B[i];
    }
    return x;
  }

  void insert(int x){
    if(!(x=proj(x)))return;
    for(int i=m;~i;--i)if((x>>i)&1){
      B[i]=x;
      for(int j=m;j>i;--j){
        if((B[j]>>i)&1)B[j]^=x;
      }
      break;
    }
  }

  int dim(){
    int ret=0;
    for(int i=m;~i;--i)ret+=B[i]!=0;
    return ret;
  }
};
