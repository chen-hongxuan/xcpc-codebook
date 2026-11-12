namespace Circle{
  circle cover(vector<vec> p){
    shuffle(p.begin(),p.end(),rnd);
    circle c;
    for(int i=0,n=p.size();i<n;++i)if(c.inside(p[i])==2){
      c={p[i],0};
      for(int j=0;j<i;++j)if(c.inside(p[j])==2){
        c=diameter(p[i],p[j]);
        for(int k=0;k<j;++k)if(c.inside(p[k])==2){
          if(auto t=circum(p[i],p[j],p[k]))c=*t;
          else{
            vec a=p[i],b=p[j];
            if(dist(a,p[k])>dist(a,b))b=p[k];
            if(dist(p[j],p[k])>dist(a,b))a=p[j],b=p[k];
            c=diameter(a,b);
          }
        }
      }
    }
    return c;
  }
}
