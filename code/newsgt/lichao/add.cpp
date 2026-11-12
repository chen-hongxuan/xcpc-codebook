void add(signed p,Line v){
  int l=tr[p].l,r=tr[p].r,mid=(l+r)>>1;
  if(better(v,tr[p].val,mid))swap(v,tr[p].val);
  if(!v.id||l==r)return;
  if(better(v,tr[p].val,l)){
    if(!lc(p))lc(p)=newnode(l,mid);
    add(lc(p),v);
  }else if(better(v,tr[p].val,r)){
    if(!rc(p))rc(p)=newnode(mid+1,r);
    add(rc(p),v);
  }
}
