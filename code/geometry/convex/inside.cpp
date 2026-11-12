// 0 内部，1 边界，2 外部。
int inside(const vec &x)const{
  int n=p.size();
  if(n==0)return 2;
  const vec &o=p[0];
  if(n==1)return x.x==o.x&&x.y==o.y?1:2;

  int a=chkside(o,p[1],x),b=chkside(o,p.back(),x);
  if(a<0||b>0)return 2;
  if(a==0||b==0){
    const vec &v=a==0?p[1]:p.back();
    return dot(x-o,x-v)<=0?1:2;
  }
  int i=sector(x);
  int s=chkside(p[i],p[i+1],x);
  if(s<0)return 2;
  return s==0?1:0;
}
