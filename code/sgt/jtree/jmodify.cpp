signed jmodify(signed p,int x,int d){
  int l=tr[p].l,r=tr[p].r;
  if(x<l||r<x)return p;
  signed q=clone(p);
  if(l==r){
    tr[q].val+=d;
    return q;
  }
  jpushdown(q);
  int mid=(l+r)>>1;
  if(x<=mid){
    lc(q)=jmodify(lc(q),x,d);
  }else{
    rc(q)=jmodify(rc(q),x,d);
  }
  pushup(q);
  return q;
}