#include <bits/stdc++.h>

#define int long long
#define VI vector<int>
#define VVI vector<VI>
#define VVVI vector<VVI>
#define VII vector<array<int,2>>
#define VIII vector<array<int,3>>

using namespace std;

inline int read(){
  int x=0,f=1;char ch=getchar();
  for(;!isdigit(ch);ch=getchar())f^=ch=='-';
  for(;isdigit(ch);ch=getchar())x=x*10+(ch^48);
  return f?x:-x;
}
inline void write(int x,char ch=0){
  if(x<0)putchar('-');
  if(!x)putchar('0');
  else{
    string line;
    do{
      int d=x%10;
      line+=(d<0?-d:d)+48;
      x/=10;
    }while(x);
    reverse(line.begin(),line.end());
    printf("%s",line.c_str());
  }
  if(ch)putchar(ch);
}
template<class T>
inline void chmin(T &x,T y){x>y?x=y:x;}
template<class T>
inline void chmax(T &x,T y){x<y?x=y:x;}

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
