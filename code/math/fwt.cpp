namespace fwt{
  inline void red(int &x){matrix::red(x);}
  constexpr int mo=matrix::mo;
  void work(int q,int n,VI &f,const matrix &C){
    int N=f.size();VI v(q,0);
    for(int i=0,p=1;i<n;++i,p*=q){
      for(int b=0;b<N;b+=p*q)for(int x=0;x<p;++x){
        for(int j=0;j<q;++j)for(int k=0;k<q;++k){
          red(v[j]+=C[j][k]*f[b+x+k*p]%mo);
        }
        for(int j=0;j<q;++j)f[b+x+j*p]=v[j],v[j]=0;
      }
    }
  }
}
