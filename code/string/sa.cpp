namespace sa{
    vector<VI> work(string &s,VI &sa,int opt){
        vector<VI> rk={sa=VI(s.size(),0)};
        for(int i=0;i<s.size();++i){
            sa[i]=i,rk[0][i]=s[i]-'a'+1;
        }
        VI newrk(s.size());
        for(int w=1;w<s.size();w<<=1){
            auto f=[&](int u){
                int fx=u+w<s.size()?rk.back()[u+w]:0;
                return array<int,2>{rk.back()[u],fx};
            };
            sort(sa.begin(),sa.end(),[&](int x,int y){
                return f(x)<f(y);
            });
            for(int i=0,j,r=1;i<s.size();i=j,++r){
                j=i+1;
                while(j<s.size()&&f(sa[i])==f(sa[j]))++j;
                for(int k=i;k<j;++k)newrk[sa[k]]=r;
            }
            if(!opt)rk[0].swap(newrk);
            else rk.push_back(newrk);
        }
        return rk;
    }
}