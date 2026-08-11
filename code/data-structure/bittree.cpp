struct BITtree{
	vector<int> s;
	inline int lowbit(int x){return x&-x;}
	void init(int x){s.assign(x+5,0);}
	void clear(){s.clear();}
	void mdf(int x,int t){
		for(;x<(int)s.size();x+=lowbit(x))s[x]+=t;
	}
	int qry(int x){
		int ret=0;
		for(;x;x-=lowbit(x))ret+=s[x];
		return ret;
	}
};