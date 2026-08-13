namespace bsgs{
  int BSGS(int a,int b,int p,int k=1){
    if(p==1||b==k)return 0;
    unordered_map<int,int>umap={};
    int m=ceil(sqrt(p))+5,R=1,ans=-1;
    for(int j=0;j<m;++j,R=R*a%p){
      umap[R*b%p]=j;
    }
    for(int i=1,Q=k*R%p;i<=m;++i,Q=Q*R%p){
      if(umap.count(Q)){
        if(ans==-1)ans=i*m-umap[Q];
        else chmin(ans,i*m-umap[Q]);
      }
    }
    return ans;
  }
  int exBSGS(int a,int b,int p){
    if(p==1)return 0;
    int k=1,cnt=0,g;
    while((g=gcd(a,p))>1){
      if(b==k)return cnt;
      if(b%g)return -1;
      b/=g,p/=g,++cnt;
      k=k*(a/g)%p;
    }
    int ans=BSGS(a,b,p,k);
    return ~ans?ans+cnt:-1;
  }
}