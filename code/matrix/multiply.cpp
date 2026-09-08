matrix operator*(const matrix &t)const{
  if(m!=t.n)return matrix();
  matrix ret(n,t.m);
  for(int i=0;i<n;++i)for(int k=0;k<m;++k){
    if(!a[i][k])continue;
    for(int j=0;j<t.m;++j){
      red(ret[i][j]+=a[i][k]*t[k][j]%mo);
    }
  }
  return ret;
}
matrix fpow(int t)const{
  if(n!=m||t<0)return matrix();
  matrix ret(n),x=*this;
  for(;t;t>>=1,x=x*x)if(t&1)ret=ret*x;
  return ret;
}