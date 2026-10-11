int query(signed p,int L,int R){
  int l=tr[p].l,r=tr[p].r;
  if(L>R||R<l||r<L)return -inf;
  if(L<=l&&r<=R)return tr[p].val;
  pushdown(p);
  int mid=(l+r)>>1,ret=-inf;
  if(L<=mid)chmax(ret,query(lc(p),L,R));
  if(mid<R)chmax(ret,query(rc(p),L,R));
  return ret;
}
