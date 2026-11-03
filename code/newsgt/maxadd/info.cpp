void apply(signed p,int v){
  if(!p||tr[p].val==-inf)return;
  tr[p].val+=v,tr[p].tag+=v;
}
void pushup(signed p){
  tr[p].val=max(tr[lc(p)].val,tr[rc(p)].val);
}
void pushdown(signed p){
  int t=tr[p].tag;
  if(!t||tr[p].l==tr[p].r)return;
  apply(lc(p),t),apply(rc(p),t);
  tr[p].tag=0;
}
