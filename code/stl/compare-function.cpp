bool cmp(int a,int b){return a>b;}
set<int,decltype(&cmp)> s(cmp);
multiset<int,decltype(&cmp)> ms(cmp);
map<int,int,decltype(&cmp)> m(cmp);
multimap<int,int,decltype(&cmp)> mm(cmp);
std::priority_queue<int,VI,decltype(&cmp)> q(cmp);
