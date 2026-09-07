void insert(signed p,int x,int d){
  int l=tr[p].l,r=tr[p].r;
  if(x<l||r<x)return;
  if(l==r){
    tr[p].val+=d;
    return;
  }
  pushdown(p);
  int mid=(l+r)>>1;
  if(x<=mid){
    if(!lc(p))lc(p)=newnode(l,mid);
    insert(lc(p),x,d);
  }else{
    if(!rc(p))rc(p)=newnode(mid+1,r);
    insert(rc(p),x,d);
  }
  pushup(p);
}