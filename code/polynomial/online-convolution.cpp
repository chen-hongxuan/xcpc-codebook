namespace SelfConv{
  inline void red(int &x){poly::red(x);}
  constexpr int mo=poly::mo;
  void solve(int l,int r,int k,poly &f,poly &B){
    if(l==r){
      red(f[l]+=B[l]);
      return;
    }
    int mid=(l+r)>>1;
    solve(l,mid,k,f,B);
    poly A(mid-l+1),P(min(l,r-l));
    for(int i=l;i<=mid;++i)A[i-l]=f[i];
    for(int i=0;i<P.size();++i)P[i]=f[i];
    poly AA=A*A,AP=A*P;
    for(int n=mid+1;n<=r;++n){
      int t=n-k,x=t-(l<<1),y=t-l;
      if(t<0)continue;
      if(0<=x&&x<AA.size())red(f[n]+=AA[x]);
      if(0<=y&&y<AP.size())red(f[n]+=2*AP[y]%mo);
    }
    solve(mid+1,r,k,f,B);
  }
}