void sum_of_subset(int n,VI &f,VI &sum){
  sum=f;
  for(int i=0;i<n;++i)for(int j=0;j<(1<<n);++j){
    if(j&(1<<i))sum[j]+=sum[j^(1<<i)];
  }
}
void diff_of_subset(int n,VI &f,VI &diff){
  diff=f;
  for(int i=0;i<n;++i)for(int j=0;j<(1<<n);++j){
    if(j&(1<<i))diff[j]-=diff[j^(1<<i)];
  }
}