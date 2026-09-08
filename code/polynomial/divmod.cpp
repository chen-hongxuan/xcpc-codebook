void shrink(){while(size()&&!f.back())f.pop_back();}
array<poly,2> divmod(const poly &t)const{
  poly a=*this,b=t;
  a.shrink(),b.shrink();
  if(a.size()<b.size())return {poly(),move(a)};
  int len=a.size()-b.size()+1;
  poly ra=a,rb=b;
  reverse(ra.f.begin(),ra.f.end()),reverse(rb.f.begin(),rb.f.end());
  ra.reduct(len),rb.reduct(len);
  poly q=ra*rb.inverse();
  q.reduct(len),reverse(q.f.begin(),q.f.end());
  poly r=a-b*q;
  r.reduct(b.size()-1),r.shrink();
  return {move(q),move(r)};
}
poly operator/(const poly &t)const{return get<0>(divmod(t));}
poly operator%(const poly &t)const{return get<1>(divmod(t));}