matrix gauss(int opt=0)const{
  if(n>m)return matrix();
  matrix r=*this;
  VI vis(n+1,1);
  for(int i=0;i<n;++i){
    for(int j=0;j<n;++j)if(vis[j]){
      if(r[j][i]){
        if(i!=j){
          vis.back()^=1;
          swap(r[i],r[j]);
        }
        break;
      }
    }
    if(!r[i][i])continue;
    int ia=qpow(r[i][i]);
    for(int j=0;j<n;++j){
      if(!r[j][i]||j==i)continue;
      int b=r[j][i]*ia%mo;
      for(int k=i;k<m;++k){
        red(r[j][k]+=mo-r[i][k]*b%mo);
      }
    }
    vis[i]=0;
  }
  if(opt&&!vis.back()&&r[0][0])r[0][0]=mo-r[0][0];
  return r;
}