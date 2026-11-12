vector<vec> intersect(const circle &c)const{
  int t=relation(c);
  if(t==0)return r==0?vector<vec>{o}:vector<vec>{};
  if(t<2||t>4)return {};
  ld d=dist(o,c.o);
  vec u=(c.o-o)*(1/d);
  ld a=((r-c.r)*(r+c.r)+d*d)/(2*d);
  vec p=o+u*a;
  if(t!=3)return {p};
  return intersect(line{p,p+vec{-u.y,u.x},0});
}
