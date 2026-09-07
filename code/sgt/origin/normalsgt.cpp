void build(signed p,int l,int r){
  tr[p]=node(l,r);
  if(l==r)return;
  int mid=(l+r)>>1;
  lc(p)=newnode(l,mid);
  rc(p)=newnode(mid+1,r);
  build(lc(p),l,mid);
  build(rc(p),mid+1,r);
}
void modify(signed p,int x,int d){
  int l=tr[p].l,r=tr[p].r;
  if(l==r){
    tr[p].val+=d;
    return;
  }
  pushdown(p);
  int mid=(l+r)>>1;
  if(x<=mid)modify(lc(p),x,d);
  else modify(rc(p),x,d);
  pushup(p);
}
int query(signed p,int L,int R){
  int l=tr[p].l,r=tr[p].r;
  if(L<=l&&r<=R)return tr[p].val;
  else if(R<l||r<L)return 0;
  pushdown(p);
  int mid=(l+r)>>1,ret=0;
  if(L<=mid)ret+=query(lc(p),L,R);
  if(mid<R)ret+=query(rc(p),L,R);
  return ret;
}
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
