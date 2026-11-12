signed jadd(signed p,int l,int r,Line v){
  if(!v.id)return p;
  signed q=p?clone(p):newnode(l,r);
  int mid=(l+r)>>1;
  if(better(v,tr[q].val,mid))swap(v,tr[q].val);
  if(!v.id||l==r)return q;
  if(better(v,tr[q].val,l))lc(q)=jadd(lc(q),l,mid,v);
  else if(better(v,tr[q].val,r))rc(q)=jadd(rc(q),mid+1,r,v);
  return q;
}
signed jadd(signed p,Line v){
  int l=p?tr[p].l:L,r=p?tr[p].r:R;
  return jadd(p,l,r,v);
}
