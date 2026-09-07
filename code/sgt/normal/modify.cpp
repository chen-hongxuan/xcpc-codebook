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