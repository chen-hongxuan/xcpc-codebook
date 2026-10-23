VI equal_span(const VI &a,int k,VIII q,int B=0){
  int n=(int)a.size()-1,cur=0;
  VI first(k+1),last(k+1),ans(q.size());
  VIII hist;
  hist.reserve(n);
  auto add=[&](int p){
    int x=a[p];
    hist.push_back({x,first[x],last[x]});
    if(!first[x])first[x]=last[x]=p;
    else chmin(first[x],p),chmax(last[x],p);
    chmax(cur,last[x]-first[x]);
  };
  auto snapshot=[&]()->array<int,2>{
    return {(int)hist.size(),cur};
  };
  auto rollback=[&](array<int,2> s){
    while((int)hist.size()>s[0]){
      auto [x,l,r]=hist.back();
      hist.pop_back();
      first[x]=l,last[x]=r;
    }
    cur=s[1];
  };
  MoRollback::work(n,move(q),add,add,snapshot,rollback,
    [&](int id,int,int){ans[id]=cur;},B);
  return ans;
}
