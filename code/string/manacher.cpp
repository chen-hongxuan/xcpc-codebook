namespace manacher{
  void work(string &x,VI &d){
    string s="#";
    for(char ch:x){
      s+=ch;
      s+='#';
    }
    int n=s.size();
    d.assign(n,0);
    for(int i=0,l=0,r=-1;i<n;++i){
      int k=(i>r)?1:min(r-i+1,d[l+r-i]);
      while(k<=i&&i+k<n&&s[i-k]==s[i+k])++k;
      d[i]=k--;
      if(i+k>r)l=i-k,r=i+k;
    }
  }
}
