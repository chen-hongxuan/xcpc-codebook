VI distinct_with_updates(const VI &a,int k,const VII &c,
  const vector<MoUpdate::query> &q,int B=0){
  VI cnt(k+1),ans(q.size());
  int cur=0;
  auto add=[&](int,int x){if(cnt[x]++==0)++cur;};
  auto del=[&](int,int x){if(--cnt[x]==0)--cur;};
  auto save=[&](int id,int,int){ans[id]=cur;};
  MoUpdate::work(a,c,q,add,del,save,B);
  return ans;
}
