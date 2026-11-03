int min_Left(signed p,int qr,int &s,int v){
  int l=tr[p].l,r=tr[p].r;
  if(qr<l)return l;
  if(r<=qr&&s+tr[p].val<=v){
    s+=tr[p].val;
    return l;
  }
  if(l==r)return r+1;
  pushdown(p);
  int mid=(l+r)>>1;
  int ret=min_Left(rc(p),qr,s,v);
  if(ret>mid+1)return ret;
  return min_Left(lc(p),qr,s,v);
}