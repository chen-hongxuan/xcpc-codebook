VI a={1,2,2,4};
int x=2;
auto l=lower_bound(a.begin(),a.end(),x);
auto r=upper_bound(a.begin(),a.end(),x);
int pos=l-a.begin(),cnt=r-l; // 0 基位置为 1，出现 2 次。
bool found=l!=a.end()&&*l==x;
