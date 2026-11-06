// codebook: area
struct polygon{
  vector<vec> p; // 沿边界依次存顶点，首点只存一次。
  ld S=0,C=0;
  bool viss=false,visc=false; // 修改 p 后将两者设回 false。

  polygon()=default;
  polygon(const vector<vec> &p):p(p){}

  ld area(){
    if(viss)return S;
    S=0;
    for(int i=1,n=p.size();i+1<n;++i){
      S+=cross(p[i]-p[0],p[i+1]-p[0]);
    }
    S=fabsl(S)/2;
    viss=true;
    return S;
  }

// codebook: perimeter
  ld perimeter(){
    if(visc)return C;
    C=0;
    for(int i=0,n=p.size();i<n;++i){
      C+=dist(p[i],p[(i+1)%n]);
    }
    visc=true;
    return C;
  }

// codebook: inside
  // 0 内部，1 边界，2 外部。
  int inside(const vec &x)const{
    bool in=false;
    for(int i=0,n=p.size();i<n;++i){
      vec a=p[i]-x,b=p[(i+1)%n]-x;
      if(a.y>b.y)swap(a,b);
      ld s=cross(a,b);
      if(s==0&&dot(a,b)<=0)return 1;
      if(a.y<=0&&b.y>0&&s>0)in=!in;
    }
    return in?0:2;
  }
};
