#include <bits/stdc++.h>

#define int long long
#define ar(u,n) array<u,n>

using namespace std;

inline int read(){
    int x=0,f=1;char ch=getchar();
    for(;!isdigit(ch);ch=getchar())f^=ch=='-';
    for(;isdigit(ch);ch=getchar())x=x*10+(ch^48);
    return f?x:-x;
}
template<typename T>inline void chmin(T &x,T y){x>y?x=y:y;}
template<typename T>inline void chmax(T &x,T y){x<y?x=y:y;}

const int mo=998244353,inf=1e15;

mt19937 rnd(time(0));

inline void red(int &x){(x>=mo)&&(x-=mo);}
inline int qpow(int x,int t=mo-2){
    int ret=1;
    for(;t;t>>=1,x=x*x%mo)if(t&1)ret=ret*x%mo;
    return ret;
}

struct cmplx{
    double Re,Im;
    cmplx(double x=0,double y=0):Re(x),Im(y){}
    cmplx operator + (const cmplx &t)const{
        return cmplx(Re+t.Re,Im+t.Im);
    }
    cmplx operator - (const cmplx &t)const{
        return cmplx(Re-t.Re,Im-t.Im);
    }
    cmplx operator * (const cmplx &t)const{
        return cmplx(Re*t.Re-Im*t.Im,Re*t.Im+Im*t.Re);
    }
    cmplx conj()const{
        return cmplx(Re,-Im);
    }
};

struct polynomial{
    
};

void solve(){

    return;
}



signed main(){
    for(int cas=read();cas--;){
        solve();

    }
    return 0;
}