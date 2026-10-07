namespace exKMP{
  void work(string &x,VI &z){
    z.assign(x.size(),0);
    for(int i=1,l=0,r=0;i<x.size();++i){
      if(i<=r&&z[i-l]+i<=r){
        z[i]=z[i-l];
      }else{
        int q=max(i,r+1);
        while(q<x.size()&&x[q]==x[q-i])++q;
        z[i]=q-i;
        (q-1>r)&&(l=i,r=q-1);
      }
    }
  }
}