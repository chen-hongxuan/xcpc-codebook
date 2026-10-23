void modify(signed p,int L,int R,int d){
  int l=tr[p].l,r=tr[p].r;
  if(L<=l&&r<=R){
    //区间修改
    return;
  }
  if(R<l||r<L)return;
  pushdown(p);
  int mid=(l+r)>>1;
  if(L<=mid)modify(lc(p),L,R,d);
  if(mid<R)modify(rc(p),L,R,d);
  pushup(p);
}