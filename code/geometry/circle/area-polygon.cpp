ld area(const vector<vec> &p)const{
  if(r==0)return 0;
  ld ans=0;
  for(int i=0,n=p.size();i<n;++i){
    vec a=p[i],b=p[(i+1)%n];
    vector<vec> q{a};
    for(const vec &x:intersect(line{a,b,2}))q.push_back(x);
    q.push_back(b);
    for(int j=1,m=q.size();j<m;++j){
      vec u=q[j-1]-o,v=q[j]-o;
      if(inside((q[j-1]+q[j])*0.5L)!=2)ans+=cross(u,v)/2;
      else ans+=r*r*atan2l(cross(u,v),dot(u,v))/2;
    }
  }
  return fabsl(ans);
}
