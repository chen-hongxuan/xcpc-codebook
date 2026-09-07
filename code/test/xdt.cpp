#include <bits/stdc++.h>
#define int long long
#define VI vector<int>
using namespace std;

template<typename T>
inline void chmax(T &x,T y){if(x<y)x=y;}
template<typename T>
inline void chmin(T &x,T y){if(x>y)x=y;}

struct SegmentTree{
  struct node{
    array<signed,2> ch{};
    int val=0,tag=0,l,r;
    node(int x=0,int y=0,signed u=0,signed v=0){
      l=x,r=y,ch[0]=u,ch[1]=v;
    }
    signed &operator[](size_t id){return ch[id];}
  };
  vector<node> tr;
  vector<signed> rootlist;
  signed pool,root;
  SegmentTree(int l=0,int r=0){
    rootlist={root=pool=1};
    tr={node(),node(l,r)};
  }
  signed newnode(int l,int r,signed u=0,signed v=0){
    tr.push_back(node(l,r,u,v));
    return ++pool;
  }
  signed &lc(signed p){return tr[p][0];}
  signed &rc(signed p){return tr[p][1];}
  void pushup(signed p){
    auto &LL=tr[lc(p)],&RR=tr[rc(p)];
    tr[p].val=LL.val+RR.val;
  }
  void pushdown(signed p){

  }
  void build(signed p,int l,int r){
    tr[p]=node(l,r);
    if(l==r)return;
    int mid=(l+r)>>1;
    lc(p)=newnode(l,mid);
    rc(p)=newnode(mid+1,r);
    build(lc(p),l,mid);
    build(rc(p),mid+1,r);
  }
  signed clone(signed p){
    tr.push_back(tr[p]);
    return ++pool;
  }
  void modify(signed p,int x,int d){
    int l=tr[p].l,r=tr[p].r;
    if(l==r){
      tr[p].val+=d;
      return;
    }
    int mid=(l+r)>>1;
    if(x<=mid)modify(lc(p),x,d);
    else modify(rc(p),x,d);
    pushup(p);
  }
  int query(signed p,int L,int R){
    int l=tr[p].l,r=tr[p].r;
    if(L<=l&&r<=R)return tr[p].val;
    else if(R<l||r<L)return 0;
    int mid=(l+r)>>1,ret=0;
    if(L<=mid)ret+=query(lc(p),L,R);
    if(mid<R)ret+=query(rc(p),L,R);
    return ret;
  }
  signed jmodify(signed p,int x,int d){
    int l=tr[p].l,r=tr[p].r;
    if(x<l||r<x)return p;
    signed q=clone(p);
    if(l==r){
      tr[q].val+=d;
      return q;
    }
    int mid=(l+r)>>1;
    if(x<=mid){
      lc(q)=jmodify(lc(p),x,d);
    }else{
      rc(q)=jmodify(rc(p),x,d);
    }
    pushup(q);
    return q;
  }
  int jquery(signed p,signed q,int L,int R){
    if((!p&&!q)||R<L)return 0;
    signed u=p?p:q;
    int l=tr[u].l,r=tr[u].r;
    if(R<l||r<L)return 0;
    if(L<=l&&r<=R)return tr[p].val-tr[q].val;
    int mid=(l+r)>>1,ret=0;
    if(L<=mid)ret+=jquery(lc(p),lc(q),L,R);
    if(mid<R)ret+=jquery(rc(p),rc(q),L,R);
    return ret;
  }
  int kth(signed p,signed q,int k){
    if(k<=0||tr[p].val-tr[q].val<k)return -1;
    while(tr[p].l<tr[p].r){
      int bas=tr[lc(p)].val-tr[lc(q)].val;
      if(k<=bas)p=lc(p),q=lc(q);
      else k-=bas,p=rc(p),q=rc(q);
    }
    return tr[p].l;
  }
  int kth(signed p,int k){return kth(p,0,k);}
  int max_Right(signed p,int ql,int &s,int v){
    int l=tr[p].l,r=tr[p].r;
    if(r<ql)return r;
    if(ql<=l&&s+tr[p].val<=v){
      s+=tr[p].val;
      return r;
    }
    if(l==r)return l-1;
    pushdown(p);
    int mid=(l+r)>>1;
    int ret=max_Right(lc(p),ql,s,v);
    if(ret<mid)return ret;
    return max_Right(rc(p),ql,s,v);
  }
  int min_Left(signed p,int qr,int &s,int v){
    int l=tr[p].l,r=tr[p].r;
    if(qr<l)return l;
    if(r<=qr&&s+tr[p].val<=v){
      s+=tr[p].val;
      return l;
    }
    if(l==r)return r+1;
    pushdown(p);
    int mid=(l+r)>>1;
    int ret=min_Left(rc(p),qr,s,v);
    if(ret>mid+1)return ret;
    return min_Left(lc(p),qr,s,v);
  }
  void insert(signed p,int x,int d){
    int l=tr[p].l,r=tr[p].r;
    if(x<l||r<x)return;
    if(l==r){
      tr[p].val+=d;
      return;
    }
    int mid=(l+r)>>1;
    if(x<=mid){
      if(!lc(p))lc(p)=newnode(l,mid);
      insert(lc(p),x,d);
    }else{
      if(!rc(p))rc(p)=newnode(mid+1,r);
      insert(rc(p),x,d);
    }
    pushup(p);
  }
  signed merge(signed p,signed q){
    if(!p||!q)return p|q;
    int l=tr[p].l,r=tr[p].r;
    if(l==r){
      tr[p].val+=tr[q].val;
      return p;
    }
    lc(p)=merge(lc(p),lc(q));
    rc(p)=merge(rc(p),rc(q));
    pushup(p);
    return p;
  }
  array<signed,2> split(signed q,int x){
    if(!q)return {0,0};
    int l=tr[q].l,r=tr[q].r;
    if(x<=l)return {0,q};
    if(r<x)return {q,0};
    auto a=split(lc(q),x);
    auto b=split(rc(q),x);
    signed p=0;
    if(a[0]||b[0]){
      lc(q)=a[0],rc(q)=b[0];
      pushup(q);
    }else q=0;
    if(a[1]||b[1]){
      p=newnode(l,r,a[1],b[1]);
      pushup(p);
    }
    return {q,p};
  }
};
