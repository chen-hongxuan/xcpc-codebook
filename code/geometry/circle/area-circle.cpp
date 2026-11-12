ld area(const circle &c)const{
  ld d=dist(o,c.o),a=min(r,c.r);
  if(d>=r+c.r)return 0;
  if(d<=fabsl(r-c.r))return pi*a*a;
  auto part=[&](const ld r,const ld R){
    ld x=acosl(clamp((d*d+r*r-R*R)/(2*d*r),-1.L,1.L));
    return r*r*(x-sinl(2*x)/2);
  };
  return clamp(part(r,c.r)+part(c.r,r),0.L,pi*a*a);
}
