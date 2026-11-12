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
