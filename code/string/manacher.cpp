namespace manacher{
  string dealfirst(string &str){
    string ret="#";
    for(char x:str){
      ret+=x;
      ret+='#';
    }
    return ret;
  }
  void work(string &x,VI &d){
    d.assign(x.size(),0);
    for(int i=0,l=0,r=-1;i<x.size();++i){
      int k=(i>r)?1:min(r-i+1,d[l+r-i]);
      while(k<=i&&i+k<x.size()&&x[i-k]==x[i+k])++k;
      d[i]=k--;
      (i+k>r)&&(l=i-k,r=i+k);
    }
  }
}