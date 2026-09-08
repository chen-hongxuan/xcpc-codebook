poly sqrt()const{
  if(!size())return poly();
  poly ret(1,1);
  int inv2=(mo+1)>>1;
  for(int len=2;len<(size()<<1);len<<=1){
    int m=min(len,size());
    ret.reduct(m);
    poly tmp(m);
    for(int i=0;i<m;++i)tmp[i]=f[i];
    tmp=tmp*ret.inverse();
    tmp.reduct(m);
    ret=ret+tmp;
    for(int &i:ret.f)i=i*inv2%mo;
  }
  return ret;
}