matrix operator*(int t)const{
  t%=mo;
  if(t<0)t+=mo;
  matrix ret=*this;
  for(int i=0;i<n;++i)for(int j=0;j<m;++j){
    ret[i][j]=ret[i][j]*t%mo;
  }
  return ret;
}
friend matrix operator*(int t,const matrix &x){
  return x*t;
}