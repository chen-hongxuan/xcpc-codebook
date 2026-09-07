void insert(signed p,int x,int d){
  int l=tr[p].l,r=tr[p].r;
  if(x<l||r<x)return;
  if(l==r){
    tr[p].val+=d;
    return;
  }
  pushdown(p);
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
  pushdown(p);
  pushdown(q);
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
  pushdown(q);
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
