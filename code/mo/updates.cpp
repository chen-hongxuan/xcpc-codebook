struct MoUpdate{
  struct query{int l,r,t,id;};
  int n,B;
  int L=1,R=0,T=0,cur=0;
  vector<query> q;
  VI ans,a;
  VII c;
  MoUpdate(int n,VIII &op,VI &_a,int B=0):
  n(n),B(B),a(_a){
    for(auto &[type,l,r]:op){
      if(type==0)c.push_back({l,r});
      else{
        int t=c.size(),id=q.size();
        q.push_back({l,r,t,id});
      }
    }
  }
  void add(const int p){
    // TODO: 加入 a[p] 的贡献，更新 cur。
  }
  void del(const int p){
    // TODO: 删除 a[p] 的贡献，更新 cur。
  }
  void addL(){add(--L);}
  void addR(){add(++R);}
  void delL(){del(L);++L;}
  void delR(){del(R);--R;}
  void change(int i){
    auto &[p,v]=c[i];
    if(L<=p&&p<=R)del(p);
    swap(a[p],v);
    if(L<=p&&p<=R)add(p);
  }
  void work(){
    ans.resize(q.size());
    if(q.empty())return;
    int m=q.size(),u=c.size();
    int b=B?B:max(n/sqrtl(m),cbrtl(1.L*n*n*u/m));
    b=min(n,max<int>(1,b));
    VI bel(n+1);
    for(int i=1;i<=n;++i)bel[i]=(i-1)/b;
    sort(q.begin(),q.end(),[&](const query &x,const query &y){
      int lx=bel[x.l],ly=bel[y.l];
      if(lx!=ly)return lx<ly;
      int rx=bel[x.r],ry=bel[y.r];
      if(rx!=ry)return (lx&1)?rx>ry:rx<ry;
      return ((lx+rx)&1)?x.t>y.t:x.t<y.t;
    });
    for(const query &x:q){
      while(T<x.t)change(T++);
      while(T>x.t)change(--T);
      while(L>x.l)addL();
      while(R<x.r)addR();
      while(L<x.l)delL();
      while(R>x.r)delR();
      ans[x.id]=cur;
    }
  }
};
