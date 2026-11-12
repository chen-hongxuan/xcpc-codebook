void insert(signed p,int L,int R,Line v){
  int l=tr[p].l,r=tr[p].r,mid=(l+r)>>1;
  if(L<=l&&r<=R){add(p,v);return;}
  if(L<=mid){
    if(!lc(p))lc(p)=newnode(l,mid);
    insert(lc(p),L,R,v);
  }
  if(R>mid){
    if(!rc(p))rc(p)=newnode(mid+1,r);
    insert(rc(p),L,R,v);
  }
}
int insert(Line v,int l,int r){
  assert(v.A[0]!=v.B[0]);
  v.id=++cnt;
  if(l<=r&&l<=R&&L<=r){
    if(!root)root=newnode(L,R);
    insert(root,l,r,v);
  }
  return v.id;
}
int insert(Line v){return insert(v,L,R);}
int insert(int xa,ld ya,int xb,ld yb){
  if(xa>xb)swap(xa,xb),swap(ya,yb);
  Line v=xa==xb?Line(0,max(ya,yb)):Line(xa,ya,xb,yb);
  return insert(v,xa,xb);
}
