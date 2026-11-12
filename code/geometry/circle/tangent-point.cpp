// 返回切点。
vector<vec> tangent(const vec &x)const{
  if(r==0)return {o};
  int s=inside(x);
  if(s==0)return {};
  if(s==1)return {x};
  ld d=dist(o,x),a=acosl(clamp(r/d,0.L,1.L));
  vec u=(x-o)*(r/d);
  return {o+u.rot(a),o+u.rot(-a)};
}
