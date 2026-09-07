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