array<int,3> exgcd(int x,int y){
  if(!y)return {x,1,0};
  auto [g,a,b]=exgcd(y,x%y);
  return {g,b,a-(x/y)*b};
}