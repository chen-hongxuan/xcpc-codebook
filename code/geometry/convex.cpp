// codebook: construct
struct convex{
  vector<vec> p; // 逆时针排列，首点只存一次。

  // Andrew 单调链。共线边只保留端点。
  void construct(vector<vec> p){
    sort(p.begin(),p.end(),[](const vec &a,const vec &b){
      return tie(a.x,a.y)<tie(b.x,b.y);
    });
    p.erase(unique(p.begin(),p.end(),
      [](const vec &a,const vec &b){return a.x==b.x&&a.y==b.y;}
    ),p.end());

    int n=p.size();
    auto &q=this->p;
    if(n<=1){
      q=p;
      return;
    }
    q.clear();
    auto add=[&](const vec &x,const int start){
      while(static_cast<int>(q.size())>=start+2&&
            chkside(q[q.size()-2],q.back(),x)<=0){
        q.pop_back();
      }
      q.push_back(x);
    };
    for(const vec &x:p)add(x,0);
    int start=q.size()-1;
    for(int i=n-2;i>=0;--i)add(p[i],start);
    q.pop_back();
  }

// codebook: inside
  // 对 construct 得到的凸包做扇形二分。0 内部，1 边界，2 外部。
  int inside(const vec &x)const{
    int n=p.size();
    if(n==0)return 2;
    const vec &o=p[0];
    if(n==1)return x.x==o.x&&x.y==o.y?1:2;

    int a=chkside(o,p[1],x),b=chkside(o,p.back(),x);
    if(a<0||b>0)return 2;
    if(a==0||b==0){
      const vec &v=a==0?p[1]:p.back();
      return dot(x-o,x-v)<=0?1:2;
    }
    int l=1,r=n-1;
    while(l+1<r){
      int m=(l+r)/2;
      if(chkside(o,p[m],x)>=0)l=m;
      else r=m;
    }
    int s=chkside(p[l],p[r],x);
    if(s<0)return 2;
    return s==0?1:0;
  }

// codebook: diameter
  // 对 construct 得到的凸包用旋转卡壳求直径。
  ld diameter()const{
    int n=p.size();
    if(n<2)return 0;
    if(n==2)return dist(p[0],p[1]);
    ld ans=0;
    for(int i=0,j=1;i<n;++i){
      int k=(i+1)%n,t=(j+1)%n;
      vec u=p[k]-p[i];
      while(cross(u,p[t]-p[j])>0){
        j=t;
        t=(j+1)%n;
      }
      chmax(ans,max(dist(p[i],p[j]),dist(p[k],p[j])));
      if(cross(u,p[t]-p[j])==0){
        chmax(ans,max(dist(p[i],p[t]),dist(p[k],p[t])));
      }
    }
    return ans;
  }
};
