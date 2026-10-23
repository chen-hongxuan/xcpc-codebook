auto cmp=[](const array<int,2> &a,
            const array<int,2> &b){
  if(a[0]!=b[0])return a[0]<b[0];
  return a[1]>b[1];
};
set<array<int,2>,decltype(cmp)> s(cmp);
multiset<array<int,2>,decltype(cmp)> ms(cmp);
map<array<int,2>,int,decltype(cmp)> m(cmp);
multimap<array<int,2>,int,decltype(cmp)> mm(cmp);
std::priority_queue<array<int,2>,VII,decltype(cmp)> q(cmp);
