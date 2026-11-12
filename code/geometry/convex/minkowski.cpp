namespace Minkowski{
  convex work(const convex &x,const convex &y){
    convex z;
    int n=x.p.size(),m=y.p.size();
    if(!n||!m)return z;
    auto start=[](const vector<vec> &p){
      int s=0,n=p.size();
      for(int i=1;i<n;++i)
        if(tie(p[i].y,p[i].x)<tie(p[s].y,p[s].x))s=i;
      return s;
    };
    int a=start(x.p),b=start(y.p);
    for(int i=0,j=0;i<n||j<m;){
      vec p=x.p[(a+i)%n],q=y.p[(b+j)%m];
      z.p.push_back(p+q);
      vec u=x.p[(a+i+1)%n]-p,v=y.p[(b+j+1)%m]-q;
      ld s=i==n?-1:j==m?1:cross(u,v);
      i+=s>=0;j+=s<=0;
    }
    return z;
  }
}
