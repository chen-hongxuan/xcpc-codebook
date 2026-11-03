void change(signed p,int x,int v){
  int l=tr[p].l,r=tr[p].r;
  if(l==r){
    chmax(tr[p].val,v),tr[p].tag=0;
    return;
  }
  pushdown(p);
  int mid=(l+r)>>1;
  if(x<=mid)change(lc(p),x,v);
  else change(rc(p),x,v);
  pushup(p);
}
