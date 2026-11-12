// {l,r} 使凸包在 x->p[l] 左侧、x->p[r] 右侧，含线上。
// 空凸包或 x 在凸包内、边界上时返回 {-1,-1}。
pair<int,int> tangent(const vec &x)const{
  int n=p.size();
  if(n==0)return {-1,-1};
  if(n<=2){
    int s=chkside(x,p[0],p.back());
    if(s==0&&dot(x-p[0],x-p.back())<=0)return {-1,-1};
    return {s<0?n-1:0,s>0?n-1:0};
  }

  auto visible=[&](const int i){
    return chkside(p[i%n],p[(i+1)%n],x)<0;
  };
  int front=sector(x),back=sector(x,-1);
  if(!visible(front))return {-1,-1};

  auto split=[&](int l,int r){
    if(r<l)r+=n;
    bool state=visible(l);
    while(l+1<r){
      int m=(l+r)/2;
      if(visible(m)==state)l=m;
      else r=m;
    }
    return r%n;
  };
  return {split(front,back),split(back,front)};
}
