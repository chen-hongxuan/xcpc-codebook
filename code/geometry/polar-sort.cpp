namespace polarsort{
  // 叉乘的乘积及其舍入残差须避免上溢和下溢。
  vector<int> porder(const vector<vec> &p){
    int n=static_cast<int>(p.size());
    vector<int> id(n);
    for(int i=0;i<n;++i)id[i]=i;
    auto half=[](const vec v){
      if(v.x==0&&v.y==0)return -1;
      return v.y<0||(v.y==0&&v.x<0)?1:0;
    };
    sort(id.begin(),id.end(),[&](const int i,const int j){
      vec a=p[i],b=p[j];
      int ha=half(a),hb=half(b);
      if(ha!=hb)return ha<hb;
      ld lhs=a.x*b.y,rhs=a.y*b.x;
      if(lhs==rhs){
        lhs=fmal(a.x,b.y,-lhs);
        rhs=fmal(a.y,b.x,-rhs);
      }
      if(lhs!=rhs)return lhs>rhs;
      ld da=max(fabsl(a.x),fabsl(a.y));
      ld db=max(fabsl(b.x),fabsl(b.y));
      if(da!=db)return da<db;
      return i<j;
    });
    return id;
  }

  vector<vec> psort(const vector<vec> &p){
    vector<vec> res;
    res.reserve(p.size());
    for(int i:porder(p))res.push_back(p[i]);
    return res;
  }
}
