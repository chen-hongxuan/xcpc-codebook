poly logarithm()const{
  poly s=derivate()*inverse();
  s.reduct(size()-1);
  s=s.integral();
  s.reduct(size());
  return s;
}