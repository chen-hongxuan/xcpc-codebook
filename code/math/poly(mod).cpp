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
    poly(int len=0,int val=0):f(VI(len,val)){}
    void fft(int opt){//0<-DFT 1<-IDFT
        for(int i=1,j=f.size()>>1,k;i<f.size();++i,j+=k){
			if(i<j)swap(f[i],f[j]);
			for(k=f.size()>>1;j>=k&&k;k>>=1)j-=k;
		}
        for(int k=1;k<f.size();k<<=1){
            int wn=qpow(gn,(mo-1)/(k<<1));
            if(opt)wn=qpow(wn);
            for(int i=0;i<f.size();i+=(k<<1)){
                for(int j=i,w=1;j<i+k;++j,w=w*wn%mo){
                    int u=f[j],v=w*f[j+k]%mo;
                    red(f[j]=u+v);
                    red(f[j+k]=u+mo-v);
                }
            }
        }
        if(opt){
            int inv=qpow(f.size());
            for(int &i:f)i=i*inv%mo;
        }
    }
    int size(){return f.size();}
    void reduct(int siz){f.resize(siz,0);}
    void bas2_extend(int siz){
        int len=1;
        while(len<siz)len<<=1;
        reduct(len);
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
    poly inverse(){
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
    poly derivate(){
        poly s(size()-1);
        for(int i=0;i+1<size();++i){
            s[i]=f[i+1]*(i+1)%mo;
        }
        return s;
    }
    poly integral(){
        poly s(size()+1);
        for(int i=1;i<=size();++i){
            s[i]=f[i]*
        }
    }
};


int n;
void solve(){
    n=read();
    poly f(n);
    for(int &i:f.f)i=read();
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