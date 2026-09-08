void fft(int opt){//0<-DFT 1<-IDFT
  int n=size();
  for(int i=1,j=n>>1,k;i<n;++i,j+=k){
    if(i<j)swap(f[i],f[j]);
    for(k=n>>1;j>=k&&k;k>>=1)j-=k;
  }
  for(int k=1;k<n;k<<=1){
    int wn=qpow(gn,(mo-1)/(k<<1));
    if(opt)wn=qpow(wn);
    for(int i=0;i<n;i+=(k<<1)){
      for(int j=i,w=1;j<i+k;++j,w=w*wn%mo){
        int u=f[j],v=w*f[j+k]%mo;
        red(f[j]=u+v);
        red(f[j+k]=u+mo-v);
      }
    }
  }
  if(opt){
    int inv=qpow(n);
    for(int &i:f)i=i*inv%mo;
  }
}