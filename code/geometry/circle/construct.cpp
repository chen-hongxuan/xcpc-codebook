namespace Circle{
  circle diameter(const vec &a,const vec &b){
    return {(a+b)*0.5L,dist(a,b)/2};
  }
  optional<circle> circum(const vec &a,const vec &b,
                         const vec &c){
    vec u=b-a,v=c-a;
    ld d=2*cross(u,v);
    if(d==0)return nullopt;
    vec w=v*dot(u,u)-u*dot(v,v);
    vec o=a+vec{w.y,-w.x}*(1/d);
    return circle{o,dist(o,a)};
  }
  optional<circle> incircle(const vec &a,const vec &b,
                           const vec &c){
    ld x=dist(b,c),y=dist(c,a),z=dist(a,b);
    ld s=fabsl(cross(b-a,c-a)),d=x+y+z;
    if(s==0)return nullopt;
    return circle{(a*x+b*y+c*z)*(1/d),s/d};
  }
}
