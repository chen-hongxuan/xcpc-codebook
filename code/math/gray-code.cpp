namespace gray_code{
  void work(int n,VI &ret){
    ret.resize(1ll<<n);
    for(int i=0;i<ret.size();++i)ret[i]=i^(i>>1);
  }
}
