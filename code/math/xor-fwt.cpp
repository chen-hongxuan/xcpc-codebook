namespace XORfwt{
  void work(VI &f,int opt){//0:FWT 1:IFWT
    int N=f.size();
    for(int p=1;p<N;p<<=1){
      for(int b=0;b<N;b+=p<<1)for(int x=0;x<p;++x){
        int u=f[b+x],v=f[b+x+p];
        red(f[b+x]=u+v);
        red(f[b+x+p]=u+mo-v);
      }
    }
    if(opt){
      int inv=qpow(N);
      for(auto &x:f)x=x*inv%mo;
    }
  }
}
