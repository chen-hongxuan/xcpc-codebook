namespace MoUpdate{
  struct query{int l,r,t,id;};
  template<class A,class D,class F>
  void work(VI a,VII c,vector<query> q,
            A add,D del,F save,int B=0){
    if(q.empty())return;
    int n=a.size()-1;
    if(!B)B=max<int>(1,pow(n,2.0/3));
    B=min(n,max<int>(1,B));
    VI bel(n+1);
    for(int i=1;i<=n;++i)bel[i]=(i-1)/B;
    sort(q.begin(),q.end(),[&](const auto &x,const auto &y){
      int lx=bel[x.l],ly=bel[y.l];
      if(lx!=ly)return lx<ly;
      int rx=bel[x.r],ry=bel[y.r];
      if(rx!=ry)return (lx&1)?rx>ry:rx<ry;
      return ((lx+rx)&1)?x.t>y.t:x.t<y.t;
    });
    int l=1,r=0,t=0;
    auto change=[&](int i){
      auto &[p,v]=c[i];
      if(l<=p&&p<=r)del(p,a[p]);
      swap(a[p],v);
      if(l<=p&&p<=r)add(p,a[p]);
    };
    for(auto [L,R,T,id]:q){
      while(t<T)change(t++);
      while(t>T)change(--t);
      while(l>L){--l;add(l,a[l]);}
      while(r<R){++r;add(r,a[r]);}
      while(l<L){del(l,a[l]);++l;}
      while(r>R){del(r,a[r]);--r;}
      save(id,L,R);
    }
  }
}
