VI a={8,1,6,2,9};
int k=2; // 从 1 计数，要求 1<=k<=a.size()。
nth_element(a.begin(),a.begin()+k-1,a.end());
int small=a[k-1]; // 第 k 小：2。
nth_element(a.begin(),a.begin()+k-1,a.end(),greater<int>());
int large=a[k-1]; // 第 k 大：8。
