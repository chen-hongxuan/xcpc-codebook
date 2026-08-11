#include <bits/stdc++.h>
using namespace std;
struct bigint{
    using ll=long long;
    using ull=unsigned long long;
    using u128=unsigned __int128;
    static constexpr ll base=1000000000LL;
    vector<ll>bit;
    int sgn;

    bigint(ll x=0){*this=x;}
    bigint(const string&s){read(s);}

    void norm(){
        while(!bit.empty()&&!bit.back())bit.pop_back();
        if(bit.empty())sgn=0;
    }

    static ull mag(ll x){
        return x<0?0ull-(ull)x:(ull)x;
    }

    bigint&operator=(ll x){
        bit.clear();
        sgn=(x>0)-(x<0);
        for(ull y=mag(x);y;y/=base)bit.push_back(y%base);
        return *this;
    }

    void read(const string&s){
        int n=s.size(),p=0,f=1;
        if(!n)throw invalid_argument("empty bigint");
        if(s[p]=='+'||s[p]=='-')f=s[p++]=='-'?-1:1;
        if(p==n)throw invalid_argument("invalid bigint");
        for(int i=p;i<n;++i)
            if(s[i]<'0'||s[i]>'9')throw invalid_argument("invalid bigint");
        bit.clear();
        sgn=f;
        for(int r=n;r>p;r-=9){
            int l=max(p,r-9);
            ll x=0;
            for(int i=l;i<r;++i)x=x*10+s[i]-'0';
            bit.push_back(x);
        }
        norm();
    }

    static int abscmp(const bigint&a,const bigint&b){
        if(a.bit.size()!=b.bit.size())
            return a.bit.size()<b.bit.size()?-1:1;
        for(int i=(int)a.bit.size()-1;i>=0;--i)
            if(a.bit[i]!=b.bit[i])return a.bit[i]<b.bit[i]?-1:1;
        return 0;
    }

    static bigint absadd(const bigint&a,const bigint&b){
        bigint r;
        r.sgn=1;
        r.bit.resize(max(a.bit.size(),b.bit.size()));
        ll carry=0;
        for(int i=0;i<(int)r.bit.size();++i){
            ll x=carry;
            if(i<(int)a.bit.size())x+=a.bit[i];
            if(i<(int)b.bit.size())x+=b.bit[i];
            r.bit[i]=x%base,carry=x/base;
        }
        if(carry)r.bit.push_back(carry);
        return r;
    }

    static bigint abssub(const bigint&a,const bigint&b){
        bigint r;
        r.sgn=1;
        r.bit.resize(a.bit.size());
        ll borrow=0;
        for(int i=0;i<(int)a.bit.size();++i){
            ll x=a.bit[i]-borrow;
            if(i<(int)b.bit.size())x-=b.bit[i];
            if(x<0)x+=base,borrow=1;
            else borrow=0;
            r.bit[i]=x;
        }
        r.norm();
        return r;
    }

    bigint operator-()const{
        bigint r=*this;
        r.sgn=-r.sgn;
        return r;
    }

    bigint operator+(const bigint&t)const{
        if(!sgn)return t;
        if(!t.sgn)return *this;
        if(sgn==t.sgn){
            bigint r=absadd(*this,t);
            r.sgn=sgn;
            return r;
        }
        int c=abscmp(*this,t);
        if(!c)return bigint();
        bigint r=c>0?abssub(*this,t):abssub(t,*this);
        r.sgn=c>0?sgn:t.sgn;
        return r;
    }

    bigint operator-(const bigint&t)const{
        return *this+(-t);
    }

    bigint operator*(const bigint&t)const{
        if(!sgn||!t.sgn)return bigint();
        bigint r;
        r.sgn=sgn*t.sgn;
        r.bit.assign(bit.size()+t.bit.size(),0);
        for(int i=0;i<(int)bit.size();++i){
            ll carry=0;
            for(int j=0;j<(int)t.bit.size()||carry;++j){
                ll x=r.bit[i+j]+carry;
                if(j<(int)t.bit.size())x+=bit[i]*t.bit[j];
                r.bit[i+j]=x%base,carry=x/base;
            }
        }
        r.norm();
        return r;
    }

    bigint&operator+=(const bigint&t){
        return *this=*this+t;
    }

    bigint&operator-=(const bigint&t){
        return *this=*this-t;
    }

    bigint&operator*=(const bigint&t){
        return *this=*this*t;
    }

    pair<bigint,ull>divabs(ull d)const{
        bigint q;
        q.sgn=1;
        q.bit.resize(bit.size());
        ull rem=0;
        for(int i=(int)bit.size()-1;i>=0;--i){
            u128 x=(u128)rem*base+bit[i];
            q.bit[i]=(ull)(x/d);
            rem=(ull)(x%d);
        }
        q.norm();
        return {q,rem};
    }

    bigint operator/(ll t)const{
        if(!t)throw domain_error("division by zero");
        auto[q,rem]=divabs(mag(t));
        if(q.sgn)q.sgn=sgn*(t<0?-1:1);
        return q;
    }

    ll operator%(ll t)const{
        if(!t)throw domain_error("division by zero");
        ull d=mag(t),rem=0;
        for(int i=(int)bit.size()-1;i>=0;--i)
            rem=(ull)(((u128)rem*base+bit[i])%d);
        return sgn<0?-(ll)rem:(ll)rem;
    }

    bigint&operator/=(ll t){
        return *this=*this/t;
    }

    friend bool operator==(const bigint&a,const bigint&b){
        return a.sgn==b.sgn&&a.bit==b.bit;
    }

    friend bool operator!=(const bigint&a,const bigint&b){
        return !(a==b);
    }

    friend bool operator<(const bigint&a,const bigint&b){
        if(a.sgn!=b.sgn)return a.sgn<b.sgn;
        if(!a.sgn)return false;
        int c=abscmp(a,b);
        return a.sgn>0?c<0:c>0;
    }

    friend bool operator>(const bigint&a,const bigint&b){
        return b<a;
    }

    friend bool operator<=(const bigint&a,const bigint&b){
        return !(b<a);
    }

    friend bool operator>=(const bigint&a,const bigint&b){
        return !(a<b);
    }

    friend ostream&operator<<(ostream&out,const bigint&x){
        if(!x.sgn)return out<<0;
        if(x.sgn<0)out<<'-';
        out<<x.bit.back();
        char old=out.fill('0');
        for(int i=(int)x.bit.size()-2;i>=0;--i)out<<setw(9)<<x.bit[i];
        out.fill(old);
        return out;
    }

    friend istream&operator>>(istream&in,bigint&x){
        string s;
        if(in>>s)x.read(s);
        return in;
    }
};