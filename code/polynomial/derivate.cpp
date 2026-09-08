poly derivate()const{
  if(size()<=1)return poly();
  poly s(size()-1);
  for(int i=0;i+1<size();++i)s[i]=f[i+1]*(i+1)%mo;
  return s;
}