// codebook: line
struct Line{
  using ld=long double;
  array<ld,2> A{},B{1,0};
  int id=0;
  Line()=default;
  Line(ld xa,ld ya,ld xb,ld yb):A{xa,ya},B{xb,yb}{}
  Line(ld k,ld b):A{0,b},B{1,k+b}{}
  ld f(ld x)const{
    ld dx=B[0]-A[0];
    return (A[1]*dx+(B[1]-A[1])*(x-A[0]))/dx;
  }
};

// codebook: tree
struct LiChaoSegmentTree{
  using ld=long double;
  using lct=LiChaoSegmentTree;
  struct node{
    array<signed,2> ch{};
    Line val;
    int l,r;
    node(int l=0,int r=0):l(l),r(r){}
  };
  inline static vector<node> tr={node(0,0)};
  inline static int cnt=0;
  int L,R;
  signed root=0;
  LiChaoSegmentTree(int l,int r):L(l),R(r){assert(l<=r);}
  LiChaoSegmentTree(const lct &)=delete;
  lct &operator=(const lct &)=delete;
  LiChaoSegmentTree(lct &&b)noexcept:
    L(b.L),R(b.R),root(exchange(b.root,0)){}
  lct &operator=(lct &&b)noexcept{
    if(this!=&b)L=b.L,R=b.R,root=exchange(b.root,0);
    return *this;
  }
  static void clear(){tr={node()};cnt=0;}
  static signed newnode(int l,int r){
    tr.emplace_back(l,r);
    return tr.size()-1;
  }
  static signed clone(signed p){
    tr.push_back(tr[p]);
    return tr.size()-1;
  }
  signed &lc(signed p){return tr[p].ch[0];}
  signed &rc(signed p){return tr[p].ch[1];}

  bool better(const Line &a,const Line &b,int x)const{
    if(!a.id||!b.id)return a.id>b.id;
    ld A=a.f(x),B=b.f(x);
    return A!=B?A>B:a.id<b.id;
  }

  // 将所需成员函数片段放在这里。

};
