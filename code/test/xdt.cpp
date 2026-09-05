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
    node(int x=0,int y=0):l(x),r(y){}
    signed &operator[](size_t id){return ch[id];}
  };
  vector<node> tr;
  VI rt;
  int pool,root;
  SegmentTree(int l=0,int r=0){
    rt={root=pool=1};
    tr={node(),node(l,r)};
  }
  signed newnode(int l,int r){
    tr.push_back(node(l,r));
    return ++pool;
  }
  #define lc tr[p][0]
  #define rc tr[p][1]
  #define lcq tr[q][0]
  #define rcq tr[q][1]
  void pushup(int p){
    auto &LL=tr[lc],&RR=tr[rc];
    tr[p].val=LL.val+RR.val;
  }
  void pushdown(int p){

  }
  void build(signed p,int l,int r){
    tr[p]=node(l,r);
    if(l==r)return;
    int mid=(l+r)>>1;
    lc=newnode(l,mid);
    rc=newnode(mid+1,r);
    build(lc,l,mid);
    build(rc,mid+1,r);
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
    if(x<=mid)modify(lc,x,d);
    else modify(rc,x,d);
    pushup(p);
  }
  int query(signed p,int L,int R){
    int l=tr[p].l,r=tr[p].r;
    if(L<=l&&r<=R)return tr[p].val;
    else if(R<l||r<L)return 0;
    int mid=(l+r)>>1,ret=0;
    if(L<=mid)ret+=query(lc,L,R);
    if(mid<R)ret+=query(rc,L,R);
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
      signed son=tr[p][0];
      son=jmodify(son,x,d);
      lcq=son;
    }else{
      signed son=tr[p][1];
      son=jmodify(son,x,d);
      rcq=son;
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
    if(L<=mid)ret+=jquery(lc,lcq,L,R);
    if(mid<R)ret+=jquery(rc,rcq,L,R);
    return ret;
  }
  int kth(signed p,signed q,int k){
    if(k<=0||tr[p].val-tr[q].val<k)return -1;
    while(tr[p].l<tr[p].r){
      int bas=tr[lc].val-tr[lcq].val;
      if(k<=bas)p=lc,q=lcq;
      else k-=bas,p=rc,q=rcq;
    }
    return tr[p].l;
  }
  int kth(int p,int k){return kth(p,0,k);}
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
    int ret=max_Right(lc,ql,s,v);
    if(ret<mid)return ret;
    return max_Right(rc,ql,s,v);
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
    int ret=min_Left(rc,qr,s,v);
    if(ret>mid+1)return ret;
    return min_Left(lc,qr,s,v);
  }
  void ins_modify(signed p,int x,int d){
    int l=tr[p].l,r=tr[p].r;
    if(x<l||r<x)return;
    if(l==r){
      tr[p].val+=d;
      return;
    }
    int mid=(l+r)>>1;
    if(x<=mid){
      signed son=tr[p][0];
      if(!son)son=newnode(l,mid);
      ins_modify(son,x,d);
      tr[p][0]=son;
    }else{
      signed son=tr[p][1];
      if(!son)son=newnode(mid+1,r);
      ins_modify(son,x,d);
      tr[p][1]=son;
    }
    pushup(p);
  }
};
