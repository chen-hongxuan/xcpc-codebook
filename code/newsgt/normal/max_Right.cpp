int max_Right(signed p,int ql,int &s,int v){
  int l=tr[p].l,r=tr[p].r;
  if(r<ql)return r;
  if(ql<=l&&s+tr[p].val<=v){
    s+=tr[p].val;
    return r;
  }
  if(l==r)return l-1;
  pushdown(p);
  int mid=(l+r)>>1;
  int ret=max_Right(lc(p),ql,s,v);
  if(ret<mid)return ret;
  return max_Right(rc(p),ql,s,v);
}