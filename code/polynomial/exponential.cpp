poly exponential()const{
  if(!size())return poly();
  poly ret(1,1);
  for(int len=2;len<(size()<<1);len<<=1){
    int m=min(len,size());
    ret.reduct(m);
    poly tmp(m);
    for(int i=0;i<m;++i)tmp[i]=f[i];
    tmp=tmp-ret.logarithm();
    red(tmp[0]+=1),ret=ret*tmp;
    ret.reduct(m);
  }
  return ret;
}