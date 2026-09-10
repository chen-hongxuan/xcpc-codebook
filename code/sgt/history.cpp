struct SegmentTree{
  struct tag{
    int mul=1,add=0,cnt=0,hadd=0;
    tag(int p=1,int q=0,int c=0,int d=0):
      mul(p),add(q),cnt(c),hadd(d){}
  };
  struct node{
    array<signed,2> ch{};
    int val=0,hval=0,l=0,r=0;
    tag lz;
    node(int x=0,int y=0):l(x),r(y){}
    signed &operator[](size_t i){return ch[i];}
  };
  vector<node> tr;
  signed pool=0,root=0;
  signed &lc(signed p){return tr[p][0];}
  signed &rc(signed p){return tr[p][1];}
  signed newnode(int l,int r){
    tr.push_back(node(l,r));
    return ++pool;
  }
  tag compose(tag x,tag y){
    return tag(y.mul*x.mul,y.mul*x.add+y.add,
      x.cnt+y.cnt*x.mul,x.hadd+y.cnt*x.add+y.hadd);
  }
  void apply(signed p,tag t){
    int len=tr[p].r-tr[p].l+1;
    tr[p].hval+=t.cnt*tr[p].val+t.hadd*len;
    tr[p].val=t.mul*tr[p].val+t.add*len;
    tr[p].lz=compose(tr[p].lz,t);
  }
  void pushup(signed p){
    tr[p].val=tr[lc(p)].val+tr[rc(p)].val;
    tr[p].hval=tr[lc(p)].hval+tr[rc(p)].hval;
  }
  void pushdown(signed p){
    if(tr[p].l==tr[p].r)return;
    auto &t=tr[p].lz;
    if(t.mul==1&&!t.add&&!t.cnt&&!t.hadd)return;
    apply(lc(p),t),apply(rc(p),t);
    t=tag();
  }
  void build(signed p,int l,int r,const VI &a){
    tr[p]=node(l,r);
    if(l==r){
      tr[p].val=tr[p].hval=a[l];
      return;
    }
    int mid=(l+r)>>1;
    lc(p)=newnode(l,mid);
    rc(p)=newnode(mid+1,r);
    build(lc(p),l,mid,a);
    build(rc(p),mid+1,r,a);
    pushup(p);
  }
  void build(const VI &a){
    pool=root=1;
    tr={node(),node(1,a.size()-1)};
    build(root,1,a.size()-1,a);
  }
  void modify(signed p,int L,int R,int mul,int add){
    int l=tr[p].l,r=tr[p].r;
    if(R<l||r<L)return;
    if(L<=l&&r<=R){
      apply(p,tag(mul,add));
      return;
    }
    pushdown(p);
    int mid=(l+r)>>1;
    if(L<=mid)modify(lc(p),L,R,mul,add);
    if(mid<R)modify(rc(p),L,R,mul,add);
    pushup(p);
  }
  void modify(int L,int R,int mul,int add){
    modify(root,L,R,mul,add);
  }
  void compose(){apply(root,tag(1,0,1,0));}
  int query1(signed p,int L,int R){
    int l=tr[p].l,r=tr[p].r;
    if(R<l||r<L)return 0;
    if(L<=l&&r<=R)return tr[p].val;
    pushdown(p);
    int mid=(l+r)>>1,ret=0;
    if(L<=mid)ret+=query1(lc(p),L,R);
    if(mid<R)ret+=query1(rc(p),L,R);
    return ret;
  }
  int query1(int L,int R){return query1(root,L,R);}
  int query2(signed p,int L,int R){
    int l=tr[p].l,r=tr[p].r;
    if(R<l||r<L)return 0;
    if(L<=l&&r<=R)return tr[p].hval;
    pushdown(p);
    int mid=(l+r)>>1,ret=0;
    if(L<=mid)ret+=query2(lc(p),L,R);
    if(mid<R)ret+=query2(rc(p),L,R);
    return ret;
  }
  int query2(int L,int R){return query2(root,L,R);}
};
