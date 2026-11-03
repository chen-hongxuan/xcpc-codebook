int kth(signed p,signed q,int k){
  if(k<=0||tr[p].val-tr[q].val<k)return -1;
  while(1){
    signed u=p?p:q;
    if(tr[u].l==tr[u].r)return tr[u].l;
    int bas=tr[lc(p)].val-tr[lc(q)].val;
    if(k<=bas)p=lc(p),q=lc(q);
    else k-=bas,p=rc(p),q=rc(q);
  }
}
int kth(signed p,int k){return kth(p,0,k);}
int kth(int k){return kth(root,0,k);}
int kth(const sgt &b,int k){
  assert(L==b.L&&R==b.R);
  return kth(root,b.root,k);
}
