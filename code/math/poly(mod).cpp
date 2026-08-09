#include <bits/stdc++.h>

#define int long long
#define VI vector<int>

using namespace std;

inline int read(){
    int x=0,f=1;char ch=getchar();
    for(;!isdigit(ch);ch=getchar())f^=ch=='-';
    for(;isdigit(ch);ch=getchar())x=x*10+(ch^48);
    return f?x:-x;
}
template<typename T>inline void chmin(T &x,T y){x>y?x=y:y;}
template<typename T>inline void chmax(T &x,T y){x<y?x=y:y;}

const int _MOD_=998244353,_G_=3;

struct poly{
    static const int mo=_MOD_,gn=_G_;
    inline void red(int &x){(x>=mo)&&(x-=mo);}
    inline int qpow(int x,int t=mo-2){
        int ret=1;
        for(;t;t>>=1,x=x*x%mo)if(t&1)ret=ret*x%mo;
        return ret;
    }
    VI f;
    poly(int len=0):f(VI(len,0)){}
    void fft(int opt){//0<-DFT 1<-IDFT
        for(int i=1,j=f.size()>>1,k;i<f.size();++i,j+=k){
			if(i<j)swap(f[i],f[j]);
			for(k=f.size()>>1;j>=k&&k;k>>=1)j-=k;
		}
        for(int k=1;k<f.size();k<<=1){
            int wn=qpow(gn,(mo-1)/(k<<1));
            if(opt)wn=qpow(wn);
            for(int i=0;i<f.size();i+=(k<<1)){
                for(int j=0,w=1;j<i+k;++j,w=w*wn%mo){
                    red(f[i+j]+=w*f[i+j+k]%mo);
                    red(f[i+j+k]+=mo-w*f[i+j+k]*2%mo);
                }
            }
        }
        if(opt){
            int inv=qpow(f.size());
            for(int &i:f)i=i*inv%mo;
        }
    }
    int size(){return f.size();}
    void extend(int siz){
        int len=1;
        while(len<=siz)len<<=1;
        f.resize(len,0);
    }
    int &operator[](size_t x){return f[x];}
    poly operator+(poly &t){
        poly ret(max(size(),t.size()));
        for(int i=0;i<ret.size();++i){
            if(i<size())ret[i]=f[i];
            if(i<t.size())red(ret[i]+=t[i]);
        }
        return ret;
    }
    poly operator-(poly &t){
        poly ret(max(size(),t.size()));
        for(int i=0;i<ret.size();++i){
            if(i<size())ret[i]=f[i];
            if(i<t.size())red(ret[i]+=mo-t[i]);
        }
        return ret;
    }
    poly operator*(poly t){
        poly s=*this;
        int len=t.size()+size();
        s.extend(len);
        t.extend(len);
        s.fft(0),t.fft(0);
        for(int i=0;i<s.size();++i){
            s[i]=s[i]*t[i]%mo;
        }
        s.fft(1);
        return s;
    }

};
int n,m;
void solve(){
    n=read(),m=read();
    poly f(n+1),g(m+1);
    for(int i=0;i<=n;++i)f[i]=read();
    for(int i=0;i<=m;++i)g[i]=read();
    poly ret=f*g;
    for(int i=0;i<=n+m;++i){
        printf("%lld ",ret[i]);
    }
    return;
}

signed main(){
    // for(int cas=read();cas--;){
        solve();

    // }
    return 0;
}