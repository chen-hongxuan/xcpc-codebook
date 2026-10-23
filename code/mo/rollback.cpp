namespace MoRollback{
  template<class AL,class AR,class S,class U,class F>
  void work(int n,VIII q,AL addL,AR addR,
            S snapshot,U rollback,F save,int B=0){
    if(q.empty())return;
    if(!B)B=max<int>(1,n/sqrt(q.size()));
    B=min(n,max<int>(1,B));
    VI bel(n+1);
    for(int i=1;i<=n;++i)bel[i]=(i-1)/B;
    sort(q.begin(),q.end(),[&](const auto &x,const auto &y){
      int a=bel[x[0]],b=bel[y[0]];
      if(a!=b)return a<b;
      return x[1]<y[1];
    });
    auto empty=snapshot();
    int last=-1,b=0,r=0;
    for(auto [L,R,id]:q){
      int now=bel[L];
      if(now!=last){
        rollback(empty),last=now;
        b=min(n,(now+1)*B),r=b;
      }
      if(R<=b){
        auto s=snapshot();
        for(int p=L;p<=R;++p)addR(p);
        save(id,L,R),rollback(s);
        continue;
      }
      while(r<R)addR(++r);
      auto s=snapshot();
      for(int p=b;p>=L;--p)addL(p);
      save(id,L,R),rollback(s);
    }
    rollback(empty);
  }
}
