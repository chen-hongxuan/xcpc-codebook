int query(int b,int p,int l,int r,int L,int R){
  if(L<=l&&r<=R)return tr[b+p].val;
  pushdown(b,p);
  int mid=(l+r)>>1,ret=-inf;
  if(L<=mid)chmax(ret,query(b,p<<1,l,mid,L,R));
  if(mid<R)chmax(ret,query(b,p<<1|1,mid+1,r,L,R));
  return ret;
}
int query(int u,int L,int R){
  auto [b,s,l,w]=c[bel[u]];
  L=max(L-off[u],l),R=min(R-off[u],l+w-1);
  if(L>R)return -inf;
  return query(b,1,0,s-1,L-l,R-l);
}
