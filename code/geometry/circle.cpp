struct circle{
  vec o;
  ld r=0;
  inline static const ld eps=1e-12L,pi=acosl(-1.L);
  static int sgn(const ld x){return (x>eps)-(x<-eps);}

  ld area()const{return pi*r*r;}
  ld perimeter()const{return 2*pi*r;}

  // 将所需成员函数片段放在这里。

};
