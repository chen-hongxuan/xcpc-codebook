struct record{int x,l,r;};
VI first,last;
void add(const int p){
  int x=a[p];
  hist.push_back({x,first[x],last[x]});
  if(!first[x])first[x]=last[x]=p;
  else chmin(first[x],p),chmax(last[x],p);
  chmax(cur,last[x]-first[x]);
}
void undo(const record &v){
  first[v.x]=v.l,last[v.x]=v.r;
}
