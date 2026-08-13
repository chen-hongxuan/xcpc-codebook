struct HASH{
  using ll=long long;
  inline static constexpr array<ll,3> MOD{_P1_,_P2_,_P3_};
  array<ll,3> value{};
  static ll norm(ll x,ll mod){x%=mod;return x<0?x+mod:x;}
  HASH(ll x=0):value({x,x,x}){}
  HASH(ll x,ll y,ll z):value({x,y,z}){}
  ll& operator[](int i){return value[i];}
  const ll& operator[](int i)const{return value[i];}
  HASH& operator+=(const HASH& x){
    for(int i=0;i<3;++i){
      if((value[i]+=x[i])>=MOD[i]){
        value[i]-=MOD[i];
      }
    }
    return *this;
  }
  HASH& operator-=(const HASH& x){
    for(int i=0;i<3;++i){
      if((value[i]-=x[i])<0){
        value[i]+=MOD[i];
      }
    }
    return *this;
  }
  HASH& operator*=(const HASH& x){
    for(int i=0;i<3;++i){
      value[i]=value[i]*x[i]%MOD[i];
    }
    return *this;
  }
  friend bool operator==(const HASH& x,const HASH& y){
    return x.value==y.value;
  }
  friend bool operator!=(const HASH& x,const HASH& y){
    return !(x==y);
  }
  friend bool operator<(const HASH& x,const HASH& y){
    return x.value<y.value;
  }
  friend HASH operator+(HASH x,const HASH& y){return x+=y;}
  friend HASH operator-(HASH x,const HASH& y){return x-=y;}
  friend HASH operator*(HASH x,const HASH& y){return x*=y;}
};
const HASH BASE{_BASE1_,BASE2_,BASE3_};