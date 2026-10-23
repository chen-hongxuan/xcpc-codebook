VII socks(const VI &a,int k,VIII q,int B=0){
  int n=a.size()-1,cur=0;
  VI cnt(k+1);
  VII ans(q.size());
  auto add=[&](int p){cur+=cnt[a[p]]++;};
  auto del=[&](int p){cur-=--cnt[a[p]];};
  auto save=[&](int id,int l,int r){
    if(l==r){ans[id]={0,1};return;}
    int len=r-l+1,den=len*(len-1)/2;
    int g=gcd(cur,den);
    ans[id]={cur/g,den/g};
  };
  Mo::work(n,move(q),add,del,save,B);
  return ans;
}
