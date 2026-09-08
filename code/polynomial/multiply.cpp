poly operator*(poly t)const{
  if(!size()||!t.size())return poly();
  poly s=*this;
  int len=t.size()+size()-1;
  s.bas2_extend(len);
  t.bas2_extend(len);
  s.fft(0),t.fft(0);
  for(int i=0;i<s.size();++i){
    s[i]=s[i]*t[i]%mo;
  }
  s.fft(1);
  s.reduct(len);
  return s;
}