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

const int inf=1e18;

inline void chmin(int &x,int y){
	x=min(x,y);
}

const int _P1_=10,_P2_=100,_P3_=1000;
const int _Q1_=10,_Q2_=100,_Q3_=1000;

struct HASH{
    static constexpr array<int,3> mo={_P1_,_P2_,_P3_};
    static constexpr array<int,3> gn={_Q1_,_Q2_,_Q3_};
    array<int,3> f;
    HASH(int a=0,int b=0,int c=0):f({a,b,c}){}
    inline void red(int &x,int y){(x>=y)&&(x-=y);}
    inline void red(array<int,3> &x){
        red(x[0],mo[0]),red(x[1],mo[1]),red(x[2],mo[2]);
    }
    array<int,3> add(array<int,3> x,array<int,3> &y){
        x[0]+=y[0],x[1]+=y[1],x[2]+=y[2];
        red(x);
        return x;
    }
    array<int,3> mul()
};