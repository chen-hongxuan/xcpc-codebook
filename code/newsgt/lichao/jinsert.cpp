signed jinsert(signed p,int l,int r,int L,int R,Line v){
  if(L>R||R<l||r<L)return p;
  if(L<=l&&r<=R)return jadd(p,l,r,v);
  signed q=p?clone(p):newnode(l,r);
  int mid=(l+r)>>1;
  if(L<=mid)lc(q)=jinsert(lc(q),l,mid,L,R,v);
  if(R>mid)rc(q)=jinsert(rc(q),mid+1,r,L,R,v);
  return q;
}
signed jinsert(signed p,int L,int R,Line v){
  int l=p?tr[p].l:this->L,r=p?tr[p].r:this->R;
  return jinsert(p,l,r,L,R,v);
}
lct jinsert(Line v,int l,int r){
  assert(v.A[0]!=v.B[0]);
  v.id=++cnt;
  lct b(L,R);
  b.root=jinsert(root,l,r,v);
  return b;
}
lct jinsert(Line v){return jinsert(v,L,R);}
lct jinsert(int xa,ld ya,int xb,ld yb){
  if(xa>xb)swap(xa,xb),swap(ya,yb);
  Line v=xa==xb?Line(0,max(ya,yb)):Line(xa,ya,xb,yb);
  return jinsert(v,xa,xb);
}
