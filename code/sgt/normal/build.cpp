void build(signed p,int l,int r){
  tr[p]=node(l,r);
  if(l==r)return;
  int mid=(l+r)>>1;
  lc(p)=newnode(l,mid);
  rc(p)=newnode(mid+1,r);
  build(lc(p),l,mid);
  build(rc(p),mid+1,r);
}