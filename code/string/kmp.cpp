namespace KMP{
  void work(string &x,VI &pi){
    pi.assign(x.size(),-1);
    for(int i=1,j=-1;i<x.size();++i){
      while(~j&&x[j+1]!=x[i])j=pi[j];
      pi[i]=(j+=x[j+1]==x[i]);
    }
  }
}