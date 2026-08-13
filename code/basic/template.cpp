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

const int mo=998244353,inf=1e15;
const double pi=acos(-1);

mt19937 rnd(time(0));

inline void red(int &x){if(x>=mo)x-=mo;}
inline int qpow(int x,int t=mo-2){
  int ret=1;
  for(;t;t>>=1,x=x*x%mo)if(t&1)ret=ret*x%mo;
  return ret;
}

void solve(){

  return;
}

signed main(){
  for(int cas=read();cas--;){
    solve();

  }
  return 0;
}