// 返回全部公切线，type=0；同心时返回空数组。
vector<line> tangent(const circle &c)const{
  vector<line> ret;
  vec d=c.o-o;
  ld h=dist(o,c.o),z=dot(d,d);
  if(!sgn(h))return ret;
  if(r==0&&c.r==0)return {{o,c.o,0}};
  for(int s:{1,-1}){
    if(s==-1&&(r==0||c.r==0))continue;
    ld a=r-s*c.r;
    int k=sgn(h-fabsl(a));
    if(k<0)continue;
    ld b=k?sqrtl(max(0.L,z-a*a)):0;
    for(int t:{-1,1}){
      vec n=(d*a+vec{-d.y,d.x}*(t*b))*(1/z);
      vec p=o+n*r;
      ret.push_back({p,p+vec{-n.y,n.x},0});
      if(b==0)break;
    }
  }
  return ret;
}
