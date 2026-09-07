signed clone(signed p){
  tr.push_back(tr[p]);
  return ++pool;
}
void jpushdown(int p){
  //TODO: 可持久化安全的
}
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
int jquery(signed p,signed q,int L,int R){
  if((!p&&!q)||R<L)return 0;
  signed u=p?p:q;
  int l=tr[u].l,r=tr[u].r;
  if(R<l||r<L)return 0;
  if(L<=l&&r<=R)return tr[p].val-tr[q].val;
  if(p)jpushdown(p);
  if(q)jpushdown(q);
  int mid=(l+r)>>1,ret=0;
  if(L<=mid)ret+=jquery(lc(p),lc(q),L,R);
  if(mid<R)ret+=jquery(rc(p),rc(q),L,R);
  return ret;
}
int kth(signed p,signed q,int k){
  if(k<=0||tr[p].val-tr[q].val<k)return -1;
  while(tr[p].l<tr[p].r){
    if(p)jpushdown(p);
    if(q)jpushdown(q);
    int bas=tr[lc(p)].val-tr[lc(q)].val;
    if(k<=bas)p=lc(p),q=lc(q);
    else k-=bas,p=rc(p),q=rc(q);
  }
  return tr[p].l;
}
int kth(signed p,int k){return kth(p,0,k);}