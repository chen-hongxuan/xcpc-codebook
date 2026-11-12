// 0 内部，1 边界，2 外部。
int inside(const vec &x)const{
  return sgn(dist(o,x)-r)+1;
}
