signed merge(signed p,signed q){
  if(!p||!q)return p|q;
  if(tr[q].val.id)add(p,tr[q].val);
  lc(p)=merge(lc(p),lc(q));
  rc(p)=merge(rc(p),rc(q));
  return p;
}
void merge(lct &b){
  assert(this!=&b&&L==b.L&&R==b.R);
  root=merge(root,b.root);
  b.root=0;
}
