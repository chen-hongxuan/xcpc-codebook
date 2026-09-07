signed merge(signed p,signed q){
  if(!p||!q)return p|q;
  int l=tr[p].l,r=tr[p].r;
  if(l==r){
    tr[p].val+=tr[q].val;
    return p;
  }
  pushdown(p);
  pushdown(q);
  lc(p)=merge(lc(p),lc(q));
  rc(p)=merge(rc(p),rc(q));
  pushup(p);
  return p;
}