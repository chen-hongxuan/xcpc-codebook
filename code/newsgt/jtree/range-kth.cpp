//放入 solve(), 每组输入 n,q、数组及 q 组 l,r,k
SegmentTree::clear();
int n=read(),q=read();
VI a(n);
for(int &x:a)x=read();
VI b=a;
sort(b.begin(),b.end());
b.erase(unique(b.begin(),b.end()),b.end());
vector<SegmentTree> v;
v.reserve(n+1);
v.emplace_back(1,b.size());
for(int x:a){
  x=lower_bound(b.begin(),b.end(),x)-b.begin()+1;
  v.push_back(v.back().jmodify(x,1));
}
while(q--){
  int l=read(),r=read(),k=read();
  int x=v[r].kth(v[l-1],k);
  write(b[x-1],'\n');
}
