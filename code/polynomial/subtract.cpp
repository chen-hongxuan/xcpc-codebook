poly operator-(const poly &t)const{
  poly ret(max(size(),t.size()));
  for(int i=0;i<ret.size();++i){
    if(i<size())ret[i]=f[i];
    if(i<t.size())red(ret[i]+=mo-t[i]);
  }
  return ret;
}