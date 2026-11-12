vector<vec> intersect(const line &l)const{
  ld d=dist(l.a,l.b);
  if(d==0)return inside(l.a)==1?vector<vec>{l.a}:vector<vec>{};
  vec p=proj(o,l),u=(l.b-l.a)*(1/d);
  int s=sgn(dist(o,p)-r);
  if(s>0)return {};
  ld h=s?sqrtl(max(0.L,r*r-dot(p-o,p-o))):0;
  vector<vec> ret;
  for(const vec &x:{p-u*h,p+u*h}){
    ld t=dot(x-l.a,u);
    if((l.type==0||sgn(t)>=0)&&
       (l.type!=2||sgn(t-d)<=0)&&
       (ret.empty()||dist(ret.back(),x)>eps))ret.push_back(x);
  }
  return ret;
}
