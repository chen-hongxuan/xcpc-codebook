struct DuJiao_sieve{
  static constexpr int mo=_MOD_;
  unordered_map<int,int> umap;
  function<int(int)> S_g,S_fg;
  template<class F,class G>
  DuJiao_sieve(int inv_g,F f,G g){
    umap={{-1,inv_g}};
    S_g=f,S_fg=g;
  }
  int calc(int n,VI &pre){
    if(umap.count(n))return umap[n];
    if(n<pre.size()){
      return umap[n]=pre[n];
    }else{
      int ret=S_fg(n);
      for(int i=2,j;i<=n;i=j+1){
        j=n/(n/i);
        int tmp=(S_g(j)+mo-S_g(i-1))%mo;
        ret=(ret-calc(n/i,pre)*tmp)%mo;
      }
      if(ret<0)ret+=mo;
      return umap[n]=ret*umap[-1]%mo;
    }
  }
};