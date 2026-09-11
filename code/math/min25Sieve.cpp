template<class A,class B>
struct Min25_sieve{
  static constexpr int mo=_MOD_;
  int n,sqn;
  VI sym,w;
  vector<VI> g;
  A S_pow;B f_pk;
  Min25_sieve(VI p,A s,B f):
  sym(move(p)),S_pow(move(s)),f_pk(move(f)){}
  inline void red(int &x){x>=mo?x-=mo:0;}
  int getid(int x){
    return x<=sqn?w.size()-x:n/x;
  }
  int prime_sum(int x,int s,VI &pre){
    int p=getid(x),ret=0;
    for(int k=0;k<sym.size();++k){
      red(ret+=sym[k]*g[k][p]%mo);
    }
    return (ret+mo-pre[s])%mo;
  }
  int dfs(int x,int k,VI &pr,VI &pre){
    if(x<=1||(k&&pr[k-1]>=x))return 0;
    int ret=prime_sum(x,k,pre);
    for(int i=k;i<pr.size()&&pr[i]<=x/pr[i];++i){
      int p=pr[i],pe=p;
      for(int e=1;pe<=x/p;++e){
        int a=f_pk(p,e,pe),b=f_pk(p,e+1,pe*p);
        ret=(ret+a*dfs(x/pe,i+1,pr,pre)+b)%mo;
        pe*=p;
      }
    }
    return ret;
  }
  int solve(int x,VI &pr,VI &pre,bool tag=0){
    if(x<=0)return 0;
    n=x,sqn=(int)sqrtl(n);
    while(sqn+1<=n/(sqn+1))++sqn;
    while(sqn>n/sqn)--sqn;
    w={0};
    for(int l=1,r;l<=n;l=r+1){
      w.push_back(n/l);
      r=n/w.back();
    }
    g.assign(sym.size(),VI(w.size()));
    for(int k=0;k<sym.size();++k){
      for(int i=1;i<w.size();++i)
        red(g[k][i]=S_pow(k,w[i])+mo-1);
    }
    VI sum(sym.size());
    for(int i=0;i<pr.size()&&pr[i]<=sqn;++i){
      int p=pr[i];
      for(int j=1;j<w.size()&&p<=w[j]/p;++j){
        int q=getid(w[j]/p),pw=1;
        for(int k=0;k<sym.size();++k){
          int tmp=g[k][q]+mo-sum[k];red(tmp);
          red(g[k][j]+=mo-pw*tmp%mo);
          pw=pw*p%mo;
        }
      }
      int pw=1;
      for(int k=0;k<sym.size();++k){
        red(sum[k]+=pw);
        pw=pw*p%mo;
      }
    }
    return tag?prime_sum(n,0,pre):(dfs(n,0,pr,pre)+1)%mo;
  }
};
