void sieve(int N,VI &prime,VI &low,VI &f){
    prime={},low=f=VI(N,0),f[1]=1;
    for(int i=2;i<N;++i){
        if(!low[i]){
            prime.push_back(i);
            for(int x=i,c=1;x<N;x*=i,++c){
                low[x]=x;
                //calculate f[x]
            }
        }
        for(int p:prime){
            if(i*p>=N)break;
            if(i%p){
                low[i*p]=p;
                f[i*p]=f[i]*f[p];
            }else{
                low[i*p]=low[i]*p;
                f[i*p]=f[i/low[i]]*f[low[i]*p];
                break;
            }
        }
    }
}