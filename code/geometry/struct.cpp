// codebook: vec
struct vec{
  ld x,y;
  vec(const ld x=0,const ld y=0):x(x),y(y){}
  vec operator+(const vec v)const{return {x+v.x,y+v.y};}
  vec operator-(const vec v)const{return {x-v.x,y-v.y};}
  vec operator*(const ld k)const{return {x*k,y*k};}
  // 逆时针旋转 t 弧度。
  vec rot(const ld &t)const{
    ld c=cosl(t),s=sinl(t);
    return {x*c-y*s,x*s+y*c};
  }
};

inline ld dot(const vec a,const vec b){
  return a.x*b.x+a.y*b.y;
}
inline ld cross(const vec a,const vec b){
  return a.x*b.y-a.y*b.x;
}
inline ld dist(const vec &x,const vec &y){
  return hypotl(x.x-y.x,x.y-y.y);
}

// a、b 互异时，沿 a 到 b 观察 c，1 表示左侧，-1 表示右侧。
// 0 表示三点共线，包括 a、b 重合的情况。
inline int chkside(const vec a,const vec b,const vec c){
  ld s=cross(b-a,c-a);
  if(s>0)return 1;
  if(s<0)return -1;
  return 0;
}

// 判断 a 是否在三角形 xyz 内或边界上。
inline bool chkinside(const vec &x,const vec &y,
                     const vec &z,const vec &a){
  int s=chkside(x,y,a),t=chkside(y,z,a),u=chkside(z,x,a);
  if(s==0&&t==0&&u==0){
    return dot(a-x,a-y)<=0||dot(a-y,a-z)<=0||dot(a-z,a-x)<=0;
  }
  return (s>=0&&t>=0&&u>=0)||(s<=0&&t<=0&&u<=0);
}

// codebook: line
struct line{
  vec a,b;
  // a+t*(b-a)，0 直线，1 射线 t>=0，2 线段 0<=t<=1。
  // a==b 时退化成一个点。
  int type=0;
};

// 按 type 判断。0 不相交，1 单点相交，2 共线重叠。
inline int meet(const line &x,const line &y){
  vec u=x.b-x.a,v=y.b-y.a,w=y.a-x.a;
  ld d=cross(u,v),t=cross(w,v),s=cross(w,u);
  if(d!=0){
    if(d<0)d=-d,t=-t,s=-s;
    return (x.type==0||(t>=0&&(x.type==1||t<=d)))
        &&(y.type==0||(s>=0&&(y.type==1||s<=d)));
  }
  if(t!=0||s!=0)return 0;

  // 共线时投影到端点坐标有变化的轴。
  bool usex=u.x!=0||v.x!=0||w.x!=0;
  auto bounds=[usex](const line &l)->pair<ld,ld>{
    ld p=usex?l.a.x:l.a.y,q=usex?l.b.x:l.b.y;
    if(p==q||l.type==2)return minmax(p,q);
    if(l.type==0)return {-finf,finf};
    if(p<q)return {p,finf};
    return {-finf,p};
  };
  auto [l1,r1]=bounds(x);
  auto [l2,r2]=bounds(y);
  ld l=max(l1,l2),r=min(r1,r2);
  if(l>r)return 0;
  return l==r?1:2;
}

// 将双方视为直线，要求交点唯一。
inline vec intersect(const line &x,const line &y){
  vec u=x.b-x.a,v=y.b-y.a;
  ld d=cross(u,v);
  assert(d!=0);
  return x.a+u*(cross(y.a-x.a,v)/d);
}

// 投影到所在直线。端点重合时返回该点。
inline vec proj(const vec &x,const line &y){
  vec u=y.b-y.a;
  ld d=dot(u,u);
  if(d==0)return y.a;
  return y.a+u*(dot(x-y.a,u)/d);
}

// 点到直线、射线或线段的距离。
inline ld distl(const vec &x,const line &l){
  vec u=l.b-l.a,v=x-l.a;
  ld d=dot(u,u),t=dot(v,u);
  if(l.type==2&&dot(x-l.b,u)>=0)v=x-l.b;
  else if(d!=0&&(l.type==0||t>0))v=v-u*(t/d);
  return hypotl(v.x,v.y);
}
