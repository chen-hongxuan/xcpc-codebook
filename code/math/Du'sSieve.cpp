template<class A,class B>
struct DuJiao_sieve{
  static constexpr int mo=_MOD_;
  unordered_map<int,int> umap;
  A S_g;B S_fg;
  DuJiao_sieve(int inv_g,A sg,B sfg):
  S_g(move(sg)),S_fg(move(sfg)){
    umap={{-1,inv_g}};
  }
  int solve(int n,VI &pre){
    if(umap.count(n))return umap[n];
    if(n<pre.size()){
      return umap[n]=pre[n];
    }else{
      int ret=S_fg(n);
      for(int i=2,j;i<=n;i=j+1){
        j=n/(n/i);
        int tmp=(S_g(j)+mo-S_g(i-1))%mo;
        ret=(ret-solve(n/i,pre)*tmp)%mo;
      }
      if(ret<0)ret+=mo;
      return umap[n]=ret*umap[-1]%mo;
    }
  }
};