namespace crt{
    array<int,3> exgcd(int x,int y){
        if(!y)return {x,1,0};
        auto [g,a,b]=exgcd(y,x%y);
        return {g,b,a-(x/y)*b};
    }
    int CRT(vector<array<int,2>> sym){
        int n=1,ret=0;
        for(auto x:sym)n=n*x[1];
        for(auto [a,r]:sym){
            int m=n/r;
            auto [g,b,y]=exgcd(m,r);
            ret=(ret+a*m*b%n)%n;
        }
        return (ret+n)%n;
    }
    int merge(array<int,2> &x,array<int,2> y){
        auto [g,u,v]=exgcd(x[1],y[1]);
        if((x[0]-y[0])%g)return 1;
        int m=y[1]/g;
        u=(u*((y[0]-x[0])/g)%m+m)%m;
        x={u*x[1]+x[0],x[1]/g*y[1]};
        return 0;
    }
    int exCRT(vector<array<int,2>> sym){
        array<int,2> ret={0,1};
        for(auto e:sym){
            if(merge(ret,e)){
                return -1;
            }
        }
        return ret[0];
    }
}