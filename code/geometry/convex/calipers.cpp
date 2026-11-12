// typ=0 求直径，typ=1 求最小外接矩形面积。
ld calipers(const int typ=0)const{
  int n=p.size();
  if(n<2)return 0;
  if(n==2)return typ?0:dist(p[0],p[1]);
  ld ans=typ?finf:0;
  for(int i=0,j=1,l=0,r=0;i<n;++i){
    int k=(i+1)%n,t=(j+1)%n;
    vec u=p[k]-p[i];
    while(cross(u,p[t]-p[j])>0){
      j=t;
      t=(j+1)%n;
    }
    if(!typ){
      chmax(ans,max(dist(p[i],p[j]),dist(p[k],p[j])));
      if(cross(u,p[t]-p[j])==0)
        chmax(ans,max(dist(p[i],p[t]),dist(p[k],p[t])));
    }else{
      if(i==0)for(int a=1;a<n;++a){
        if(dot(u,p[a]-p[l])<0)l=a;
        if(dot(u,p[a]-p[r])>0)r=a;
      }
      while(dot(u,p[(l+1)%n]-p[l])<0)l=(l+1)%n;
      while(dot(u,p[(r+1)%n]-p[r])>0)r=(r+1)%n;
      ld s=cross(u,p[j]-p[i])*dot(u,p[r]-p[l])/dot(u,u);
      chmin(ans,s);
    }
  }
  return ans;
}
