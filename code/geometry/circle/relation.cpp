// 0 重合，1 内含，2 内切，3 相交，4 外切，5 相离。
int relation(const circle &c)const{
  ld d=dist(o,c.o);
  if(!sgn(d)&&!sgn(r-c.r))return 0;
  int a=sgn(d-fabsl(r-c.r));
  if(a<0)return 1;
  if(a==0)return 2;
  int b=sgn(d-r-c.r);
  return b<0?3:b==0?4:5;
}
