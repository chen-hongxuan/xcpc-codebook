VI a={2,1,1,2,2};
auto it=unique(a.begin(),a.end()); // 连续去重。
a.erase(it,a.end()); // {2,1,2}。
sort(a.begin(),a.end());
a.erase(unique(a.begin(),a.end()),a.end()); // {1,2}。
