struct OrderedMultiset{
  ordered_set<pair<int,int>> t;
  int id=0;
  void insert(int x){t.insert({x,id++});}
  bool erase_one(int x){
    auto it=t.lower_bound({x,LLONG_MIN});
    if(it==t.end()||it->first!=x)return false;
    t.erase(it);return true;
  }
  int lt(int x)const{return t.order_of_key({x,LLONG_MIN});}
  int le(int x)const{return t.order_of_key({x,LLONG_MAX});}
};
