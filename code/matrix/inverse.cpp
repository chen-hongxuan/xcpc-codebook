matrix inv()const{
  if(n!=m)return matrix();
  matrix tmp(n,n<<1),ret(n,n);
  for(int i=0;i<n;++i){
    for(int j=0;j<n;++j)tmp[i][j]=a[i][j];
    tmp[i][i+n]=1;
  }
  tmp=tmp.gauss();
  for(int i=0;i<n;++i)if(!tmp[i][i])return matrix();
  for(int i=0;i<n;++i){
    int b=qpow(tmp[i][i]);
    for(int j=0;j<n;++j)ret[i][j]=tmp[i][j+n]*b%mo;
  }
  return ret;
}