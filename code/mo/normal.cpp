namespace Mo{
  template<class AL,class AR,class DL,class DR,class F>
  void work(int n,VIII q,AL addL,AR addR,
            DL delL,DR delR,F save,int B=0){
    if(q.empty())return;
    if(!B)B=max<int>(1,n/sqrt(q.size()));
    B=min(n,max<int>(1,B));
    VI bel(n+1);
    for(int i=1;i<=n;++i)bel[i]=(i-1)/B;
    sort(q.begin(),q.end(),[&](const auto &x,const auto &y){
      int a=bel[x[0]],b=bel[y[0]];
      if(a!=b)return a<b;
      return (a&1)?x[1]>y[1]:x[1]<y[1];
    });
    int l=1,r=0;
    for(auto [L,R,id]:q){
      while(l>L)addL(--l);
      while(r<R)addR(++r);
      while(l<L)delL(l++);
      while(r>R)delR(r--);
      save(id,L,R);
    }
  }
  template<class A,class D,class F>
  void work(int n,VIII q,A add,D del,F save,int B=0){
    work(n,move(q),add,add,del,del,save,B);
  }
}
