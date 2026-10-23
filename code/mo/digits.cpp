VI divisible_substrings(const string &s,int p,VIII q,int B=0){
  int n=s.size(),cur=0;
  VI ans(q.size());
  if(p==2||p==5){
    VI cnt(n+1),sum(n+1);
    for(int i=1;i<=n;++i){
      int ok=(s[i-1]-'0')%p==0;
      cnt[i]=cnt[i-1]+ok;
      sum[i]=sum[i-1]+ok*i;
    }
    for(auto [l,r,id]:q)
      ans[id]=sum[r]-sum[l-1]-(l-1)*(cnt[r]-cnt[l-1]);
    return ans;
  }
  VI a(n+2);
  for(int i=n,w=1;i;--i,w=w*10%p)
    a[i]=((s[i-1]-'0')*w+a[i+1])%p;
  VI val(a.begin()+1,a.end());
  sort(val.begin(),val.end());
  val.erase(unique(val.begin(),val.end()),val.end());
  for(int i=1;i<=n+1;++i)
    a[i]=lower_bound(val.begin(),val.end(),a[i])-val.begin()+1;
  for(auto &t:q)++t[1];
  VI cnt(val.size()+1);
  auto add=[&](int x){cur+=cnt[a[x]]++;};
  auto del=[&](int x){cur-=--cnt[a[x]];};
  auto save=[&](int id,int,int){ans[id]=cur;};
  Mo::work(n+1,move(q),add,del,save,B);
  return ans;
}
