struct MoRollback{
  struct query{int l,r,id;};
  struct record{int x,old;}; // 按题目修改历史记录。
  struct state{int top,L,R,cur;};
  int n,B;
  int L=1,R=0,cur=0;
  vector<query> q;
  vector<record> hist;
  VI ans,a;
  MoRollback(int n,const VII &Q,const VI &_a,int B=0):
  n(n),B(B),a(_a){
    int m=Q.size();
    q.resize(m);
    for(int i=0;i<m;++i)q[i]={Q[i][0],Q[i][1],i};
  }
  void add(const int p){
    // TODO: 记录统计字段旧值，再加入 a[p] 的贡献。
  }
  void undo(const record &v){
    // TODO: 根据 v 恢复统计字段。
  }
  void addL(){add(--L);}
  void addR(){add(++R);}
  state snapshot()const{
    return {(int)hist.size(),L,R,cur};
  }
  void rollback(const state &s){
    while((int)hist.size()>s.top){
      undo(hist.back());
      hist.pop_back();
    }
    L=s.L,R=s.R,cur=s.cur;
  }
  void work(){
    ans.resize(q.size());
    if(q.empty())return;
    int b=B?B:max<int>(1,n/sqrt(q.size()));
    b=min(n,max<int>(1,b));
    VI bel(n+1);
    for(int i=1;i<=n;++i)bel[i]=(i-1)/b;
    sort(q.begin(),q.end(),[&](const query &x,const query &y){
      int u=bel[x.l],v=bel[y.l];
      return u!=v?u<v:x.r<y.r;
    });
    auto empty=snapshot();
    int block=-1,edge=0;
    for(const query &x:q){
      int now=bel[x.l];
      if(now!=block){
        rollback(empty),block=now;
        edge=min(n,(now+1)*b);
        L=edge+1,R=edge;
      }
      if(x.r<=edge){
        auto s=snapshot();
        L=x.l,R=L-1;
        while(R<x.r)addR();
        ans[x.id]=cur;
        rollback(s);
      }else{
        while(R<x.r)addR();
        auto s=snapshot();
        while(L>x.l)addL();
        ans[x.id]=cur;
        rollback(s);
      }
    }
    rollback(empty);
  }
};
