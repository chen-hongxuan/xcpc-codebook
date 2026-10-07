void modify(int b,int p,int l,int r,
            int L,int R,int v){
  if(L<=l&&r<=R){apply(b+p,v);return;}
  pushdown(b,p);
  int mid=(l+r)>>1;
  if(L<=mid)modify(b,p<<1,l,mid,L,R,v);
  if(mid<R)modify(b,p<<1|1,mid+1,r,L,R,v);
  pushup(b,p);
}
void modify(int u,int L,int R,int v){
  auto [b,s,l,w]=c[bel[u]];
  L=max(L-off[u],l),R=min(R-off[u],l+w-1);
  if(L>R)return;
  modify(b,1,0,s-1,L-l,R-l,v);
}
