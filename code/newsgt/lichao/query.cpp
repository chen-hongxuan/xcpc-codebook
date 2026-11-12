pair<ld,int> query(int x)const{
  Line v;
  if(L<=x&&x<=R)for(signed p=root;p;){
    int l=tr[p].l,r=tr[p].r,mid=(l+r)>>1;
    if(better(tr[p].val,v,x))v=tr[p].val;
    p=tr[p].ch[x>mid];
  }
  ld y=v.id?v.f(x):-finf;
  return {y,v.id};
}
