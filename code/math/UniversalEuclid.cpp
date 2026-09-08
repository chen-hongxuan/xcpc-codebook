template<class T>struct MegaEuclid{
  T unit;
  function<T(T,T)> D;
  template<class F>
  MegaEuclid(T w,F f):unit(w),D(f){}
  inline T qpow(T x,int t){
    T ret=unit;
    for(;t;t>>=1,x=D(x,x))if(t&1)ret=D(ret,x);
    return ret;
  }
  T solve(int n,int a,int b,int c,T u,T r){
    int qa=a/c,qb=b/c;
    if(qa||qb){
        T R=D(r,qpow(u,qa)),U=qpow(u,qb);
        return D(U,solve(n,a%c,b%c,c,u,R));
    }
    int m=((__int128)a*n+b)/c;
    if(!m)return qpow(r,n);
    int x=((__int128)c*m-b+a-1)/a;
    T ret=solve(m-1,c,c-b-1,a,r,u);
    return D(D(r,ret),D(u,qpow(r,n-x)));
  }
};