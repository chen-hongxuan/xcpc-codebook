friend matrix &operator*=(matrix &x,const matrix &y){
  return x=x*y;
}
friend matrix &operator*=(matrix &x,int y){
  return x=x*y;
}