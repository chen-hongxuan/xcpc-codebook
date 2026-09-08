matrix operator+(const matrix &t)const{
  if(n!=t.n||m!=t.m)return matrix();
  matrix ret=*this;
  for(int i=0;i<n;++i)for(int j=0;j<m;++j){
    red(ret[i][j]+=t[i][j]);
  }
  return ret;
}