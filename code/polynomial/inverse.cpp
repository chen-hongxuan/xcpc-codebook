poly inverse()const{
  poly ret(1,qpow(f[0]));
  for(int len=2;len<(size()<<1);len<<=1){
    poly tmp(min(len,size()));
    for(int i=0;i<tmp.size();++i){
      tmp[i]=f[i];
    }
    tmp=tmp*ret;
    tmp.reduct(len);
    for(int i=0;i<len;++i){
      tmp[i]=(mo-tmp[i])%mo;
    }
    red(tmp[0]+=2);
    ret=ret*tmp;
    ret.reduct(len);
  }
  ret.reduct(size());
  return ret;
}