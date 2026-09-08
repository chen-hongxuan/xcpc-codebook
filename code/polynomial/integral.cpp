poly integral()const{
  poly s(size()+1);
  if(!size())return s;
  VI inv(size()+1);
  inv[1]=1;
  for(int i=2;i<=size();++i)inv[i]=-mo/i*inv[mo%i]%mo;
  for(int i=1;i<=size();++i)s[i]=f[i-1]*(inv[i]+mo)%mo;
  return s;
}