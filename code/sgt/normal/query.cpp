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