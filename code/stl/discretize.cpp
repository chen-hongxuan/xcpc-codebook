VI b=a;
sort(b.begin(),b.end());
b.erase(unique(b.begin(),b.end()),b.end());
int id=lower_bound(b.begin(),b.end(),x)-b.begin();
