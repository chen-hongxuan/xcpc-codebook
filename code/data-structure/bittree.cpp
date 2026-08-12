struct BitTree{
	VI s;
	int n;
	BitTree(int n=0):s(VI(n+3,0)),n(n){}
	void add(int x,int t){
		if(x>n)return;
		for(;x<n;x+=x&-x)s[x]+=t;
	}
	int ask(int x){
		if(x<=0)return 0;
		chmin(x,n);
		int ret=0;
		for(;x;x-=x&-x)ret+=s[x];
		return ret;
	}
	int find(int val){
		// find min{x|ask(x)>=val}
		if(val<=0)return 0;
		int p=0;
		for(int i=1<<__lg(n);i;i>>=1){
			if(p+i<=n&&val>s[p+i]){
				p+=i;
				val-=s[p];
			}
		}
		return p+1;
	}
};