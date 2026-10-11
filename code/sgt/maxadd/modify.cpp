void modify(signed p,int L,int R,int v){
  int l=tr[p].l,r=tr[p].r;
  if(L>R||R<l||r<L)return;
  if(L<=l&&r<=R){apply(p,v);return;}
  pushdown(p);
  int mid=(l+r)>>1;
  if(L<=mid)modify(lc(p),L,R,v);
  if(mid<R)modify(rc(p),L,R,v);
  pushup(p);
}
