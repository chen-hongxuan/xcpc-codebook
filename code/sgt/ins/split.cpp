array<signed,2> split(signed q,int x){
  if(!q)return {0,0};
  int l=tr[q].l,r=tr[q].r;
  if(x<=l)return {0,q};
  if(r<x)return {q,0};
  pushdown(q);
  auto a=split(lc(q),x);
  auto b=split(rc(q),x);
  signed p=0;
  if(a[0]||b[0]){
    lc(q)=a[0],rc(q)=b[0];
    pushup(q);
  }else q=0;
  if(a[1]||b[1]){
    p=newnode(l,r,a[1],b[1]);
    pushup(p);
  }
  return {q,p};
}