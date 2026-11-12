struct Mo{
  struct query{int l,r,id;};
  int n,B;
  int L=1,R=0,cur=0;
  vector<query> q;
  VI ans,a;
  Mo(int n,VII &Q,VI &_a,const int B=0):
  n(n),B(B),a(_a){
    q.resize(Q.size());
    for(int i=0;i<Q.size();++i){
      q[i]={Q[i][0],Q[i][1],i};
    }
  }
  void addL(){
    --L;
    // TODO: 加入 a[L] 的贡献，更新 cur。
  }
  void addR(){
    ++R;
    // TODO: 加入 a[R] 的贡献，更新 cur。
  }
  void delL(){
    // TODO: 删除 a[L] 的贡献，更新 cur。
    ++L;
  }
  void delR(){
    // TODO: 删除 a[R] 的贡献，更新 cur。
    --R;
  }
  void work(){
    ans.resize(q.size());
    if(q.empty())return;
    int b=B?B:max<int>(1,n/sqrt(q.size()));
    b=min(n,max<int>(1,b));
    VI bel(n+1);
    for(int i=1;i<=n;++i)bel[i]=(i-1)/b;
    sort(q.begin(),q.end(),[&](query &x,query &y){
      int u=bel[x.l],v=bel[y.l];
      if(u!=v)return u<v;
      return (u&1)?x.r>y.r:x.r<y.r;
    });
    for(const query &x:q){
      while(L>x.l)addL();
      while(R<x.r)addR();
      while(L<x.l)delL();
      while(R>x.r)delR();
      ans[x.id]=cur;
    }
  }
};
