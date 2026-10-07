void change(int b,int p,int l,int r,
            int x,int pos,int v){
  if(l==r){put(b+p,pos,v);return;}
  pushdown(b,p);
  int mid=(l+r)>>1;
  if(x<=mid)change(b,p<<1,l,mid,x,pos,v);
  else change(b,p<<1|1,mid+1,r,x,pos,v);
  pushup(b,p);
}
void change(int u,int x,int v){
  auto [b,s,l,w]=c[bel[u]];
  int pos=x-off[u];
  assert(l<=pos&&pos<l+w);
  change(b,1,0,s-1,pos-l,pos,v);
}
