signed jmodify(signed p,int l,int r,int x,int d){
  if(x<l||r<x)return p;
  signed q=p?clone(p):newnode(l,r);
  if(l==r){
    tr[q].val+=d;
    return q;
  }
  int mid=(l+r)>>1;
  if(x<=mid){
    lc(q)=jmodify(lc(q),l,mid,x,d);
  }else{
    rc(q)=jmodify(rc(q),mid+1,r,x,d);
  }
  pushup(q);
  return q;
}
signed jmodify(signed p,int x,int d){
  int l=p?tr[p].l:L,r=p?tr[p].r:R;
  return jmodify(p,l,r,x,d);
}
sgt jmodify(int x,int d){
  sgt b(L,R);
  b.root=jmodify(root,x,d);
  return b;
}
