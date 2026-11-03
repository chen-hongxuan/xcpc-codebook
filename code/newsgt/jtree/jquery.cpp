int jquery(signed p,signed q,int L,int R){
  if(p==q||R<L)return 0;
  signed u=p?p:q;
  int l=tr[u].l,r=tr[u].r;
  if(R<l||r<L)return 0;
  if(L<=l&&r<=R)return tr[p].val-tr[q].val;
  int mid=(l+r)>>1,ret=0;
  if(L<=mid)ret+=jquery(lc(p),lc(q),L,R);
  if(mid<R)ret+=jquery(rc(p),rc(q),L,R);
  return ret;
}
int jquery(const sgt &b,int l,int r){
  assert(L==b.L&&R==b.R);
  return jquery(root,b.root,l,r);
}
