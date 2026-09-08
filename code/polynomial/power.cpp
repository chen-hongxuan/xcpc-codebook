poly power(int k)const{
  if(!size())return poly();
  k=(k%mo+mo)%mo;
  poly ret=logarithm();
  for(int &i:ret.f)i=i*k%mo;
  return ret.exponential();
}