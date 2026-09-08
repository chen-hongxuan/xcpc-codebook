#include <bits/stdc++.h>

#define int long long
#define VI vector<int>

using namespace std;

inline int read(){
  int x=0,f=1;signed ch=getchar();
  for(;!isdigit(ch);ch=getchar())f^=ch=='-';
  for(;isdigit(ch);ch=getchar())x=x*10+(ch^48);
  return f?x:-x;
}
template<typename T>inline void chmin(T &x,T y){x>y?x=y:y;}
template<typename T>inline void chmax(T &x,T y){x<y?x=y:y;}

const int _MOD_=998244353,_G_=3;

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
  void shrink(){while(size()&&!f.back())f.pop_back();}
  void bas2_extend(int siz){
    int len=1;
    while(len<siz)len<<=1;
    reduct(len);
  }
  int &operator[](size_t x){return f[x];}
  const int &operator[](size_t x)const{return f[x];}
  void fft(int opt){//0<-DFT 1<-IDFT
    int n=size();
    for(int i=1,j=n>>1,k;i<n;++i,j+=k){
      if(i<j)swap(f[i],f[j]);
      for(k=n>>1;j>=k&&k;k>>=1)j-=k;
    }
    for(int k=1;k<n;k<<=1){
      int wn=qpow(gn,(mo-1)/(k<<1));
      if(opt)wn=qpow(wn);
      for(int i=0;i<n;i+=(k<<1)){
        for(int j=i,w=1;j<i+k;++j,w=w*wn%mo){
          int u=f[j],v=w*f[j+k]%mo;
          red(f[j]=u+v);
          red(f[j+k]=u+mo-v);
        }
      }
    }
    if(opt){
      int inv=qpow(n);
      for(int &i:f)i=i*inv%mo;
    }
  }
  poly operator+(const poly &t)const{
    poly ret(max(size(),t.size()));
    for(int i=0;i<ret.size();++i){
      if(i<size())ret[i]=f[i];
      if(i<t.size())red(ret[i]+=t[i]);
    }
    return ret;
  }
  poly operator-(const poly &t)const{
    poly ret(max(size(),t.size()));
    for(int i=0;i<ret.size();++i){
      if(i<size())ret[i]=f[i];
      if(i<t.size())red(ret[i]+=mo-t[i]);
    }
    return ret;
  }
  poly operator*(poly t)const{
    if(!size()||!t.size())return poly();
    poly s=*this;
    int len=t.size()+size()-1;
    s.bas2_extend(len);
    t.bas2_extend(len);
    s.fft(0),t.fft(0);
    for(int i=0;i<s.size();++i){
      s[i]=s[i]*t[i]%mo;
    }
    s.fft(1);
    s.reduct(len);
    return s;
  }
  poly inverse()const{
    poly ret(1,qpow(f[0]));
    for(int len=2;len<(size()<<1);len<<=1){
      poly tmp(min(len,size()));
      for(int i=0;i<tmp.size();++i){
        tmp[i]=f[i];
      }
      tmp=tmp*ret;
      tmp.reduct(len);
      for(int i=0;i<len;++i){
        tmp[i]=(mo-tmp[i])%mo;
      }
      red(tmp[0]+=2);
      ret=ret*tmp;
      ret.reduct(len);
    }
    ret.reduct(size());
    return ret;
  }
  poly derivate()const{
    if(size()<=1)return poly();
    poly s(size()-1);
    for(int i=0;i+1<size();++i)s[i]=f[i+1]*(i+1)%mo;
    return s;
  }
  poly integral()const{
    poly s(size()+1);
    if(!size())return s;
    VI inv(size()+1);
    inv[1]=1;
    for(int i=2;i<=size();++i)inv[i]=-mo/i*inv[mo%i]%mo;
    for(int i=1;i<=size();++i)s[i]=f[i-1]*(inv[i]+mo)%mo;
    return s;
  }
  poly logarithm()const{
    poly s=derivate()*inverse();
    s.reduct(size()-1);
    s=s.integral();
    s.reduct(size());
    return s;
  }
  poly exponential()const{
    if(!size())return poly();
    poly ret(1,1);
    for(int len=2;len<(size()<<1);len<<=1){
      int m=min(len,size());
      ret.reduct(m);
      poly tmp(m);
      for(int i=0;i<m;++i)tmp[i]=f[i];
      tmp=tmp-ret.logarithm();
      red(tmp[0]+=1),ret=ret*tmp;
      ret.reduct(m);
    }
    return ret;
  }
  poly power(int k)const{
    if(!size())return poly();
    k=(k%mo+mo)%mo;
    poly ret=logarithm();
    for(int &i:ret.f)i=i*k%mo;
    return ret.exponential();
  }
  poly sqrt()const{
    if(!size())return poly();
    poly ret(1,1);
    int inv2=(mo+1)>>1;
    for(int len=2;len<(size()<<1);len<<=1){
      int m=min(len,size());
      ret.reduct(m);
      poly tmp(m);
      for(int i=0;i<m;++i)tmp[i]=f[i];
      tmp=tmp*ret.inverse();
      tmp.reduct(m);
      ret=ret+tmp;
      for(int &i:ret.f)i=i*inv2%mo;
    }
    return ret;
  }
  array<poly,2> divmod(const poly &t)const{
    poly a=*this,b=t;
    a.shrink(),b.shrink();
    if(a.size()<b.size())return {poly(),a};
    int len=a.size()-b.size()+1;
    poly ra=a,rb=b;
    reverse(ra.f.begin(),ra.f.end()),reverse(rb.f.begin(),rb.f.end());
    ra.reduct(len),rb.reduct(len);
    poly q=ra*rb.inverse();
    q.reduct(len),reverse(q.f.begin(),q.f.end());
    poly r=a-b*q;
    r.reduct(b.size()-1),r.shrink();
    return {q,r};
  }
  poly operator/(const poly &t)const{return divmod(t)[0];}
  poly operator%(const poly &t)const{return divmod(t)[1];}
};


int n;
void solve(){
  n=read();
  poly f(n);
  for(int &i:f.f)i=(read()%f.mo+f.mo)%f.mo;
  poly g=f.inverse();
  for(int i:g.f)printf("%lld ",i);
  return;
}

signed main(){
  // for(int cas=read();cas--;){
    solve();

  // }
  return 0;
}
