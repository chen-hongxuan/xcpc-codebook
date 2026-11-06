// 旧版凸包代码，仅供代码风格参考。
struct point{
	double x,y;
	point(const double a=0,const double b=0){x=a,y=b;}
	point operator + (const point a){return point(x+a.x,y+a.y);}
	point operator - (const point a){return point(x-a.x,y-a.y);}
};
vector<point> ConstructConvex(vector<point> p){
	sort(p.begin(),p.end(),[](const point a,const point b){
		return mpr(a.x,a.y)<mpr(b.x,b.y);
	});
	vector<int> sta,vis;
	sta.resize(p.size()+3);
	vis.resize(p.size()+3);
	int tp;
	sta[tp=1]=0;
	auto crossProduct=[&](const point a,const point b){
		return a.x*b.y-a.y*b.x;
	};
	for(int i=1;i<p.size();++i){
		while(tp>1&&crossProduct(p[sta[tp]]-p[sta[tp-1]],p[i]-p[sta[tp]])<=0)
			vis[sta[tp--]]=0;
		vis[sta[++tp]=i]=1;
	}
	for(int i=p.size()-2,q=tp;i>=0;--i)if(!vis[i]){
		while(tp>q&&crossProduct(p[sta[tp]]-p[sta[tp-1]],p[i]-p[sta[tp]])<=0)
			vis[sta[tp--]]=0;
		vis[sta[++tp]=i]=1;
	}
	vector<point> res;
	for(int i=1;i<=tp;++i)res.pb(p[sta[i]]);
	return res;
}
