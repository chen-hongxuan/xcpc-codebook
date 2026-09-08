int det()const{
  if(n!=m)return -1;
  matrix tmp=gauss(1);
  int ret=1;
  for(int i=0;i<n;++i)ret=ret*tmp[i][i]%mo;
  return ret;
}