struct cmplx{
    double Re,Im;
    cmplx(double x=0,double y=0):Re(x),Im(y){}
    cmplx operator + (const cmplx &t)const{
        return cmplx(Re+t.Re,Im+t.Im);
    }
    cmplx operator - (const cmplx &t)const{
        return cmplx(Re-t.Re,Im-t.Im);
    }
    cmplx operator * (const cmplx &t)const{
        return cmplx(Re*t.Re-Im*t.Im,Re*t.Im+Im*t.Re);
    }
    cmplx conj()const{
        return cmplx(Re,-Im);
    }
};
void fft(vector<cmplx> &f,int tag){//0:DFT 1:IDFT
	for(int i=1,j=f.size()>>1,k;i<f.size();++i,j+=k){
		if(i<j)swap(f[i],f[j]);
		for(k=f.size()>>1;j>=k&&k;k>>=1)j-=k;
	}
	for(int l=2;l<=f.size();l<<=1){
		cmplx w(cos(pi*2/l),sin(pi*2/l));
		if(!tag)w=w.conj();
		for(int i=0;i<f.size();i+=l){
			cmplx s(1,0);
			for(int j=i;j<i+l/2;++j,s=s*w){
				f[j+l/2]=f[j]-s*f[j+l/2];
				f[j]=f[j]+f[j]-f[j+l/2];
			}
		}
	}
	if(tag)for(auto &x:f){
		x.Re/=f.size();
		x.Im/=f.size();
	}
}