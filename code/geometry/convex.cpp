struct convex{
  vector<vec> p; // 逆时针排列，首点只存一次。

  // h>=3 时定位 p[0] 的射线。dir=-1 表示背向 x。
  int sector(const vec &x,const int dir=1)const{
    int n=p.size();
    vec u=(x-p[0])*dir;
    if(cross(p[1]-p[0],u)<0)return 0;
    if(cross(p.back()-p[0],u)>0)return n-1;
    int l=1,r=n-1;
    while(l+1<r){
      int m=(l+r)/2;
      if(cross(p[m]-p[0],u)>=0)l=m;
      else r=m;
    }
    return l;
  }

  // 将所需成员函数片段放在这里。

};
