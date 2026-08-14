struct segmenttree1{
    struct node{
        array<int,2> ch;
        int val;
        int &operator[](size_t i){return ch[i];}
    };
    vector<node> tr;
    int max_right(int p,int l,int r,int ql,int &s,int v){
        if(r<ql)return -1;
        if(l<=ql){
            int tmp=s+tr[p].val;
            if(tmp<v){
                s=tmp;
                return -1;
            }
            if(l==r)return l;
        }
        int mid=(l+r)>>1,ret;
        // pushdown(p);
        ret=max_right(tr[p][0],l,mid,ql,s,v);
        if(ret!=-1)return ret;
        return max_right(tr[p][1],mid+1,r,ql,s,v);
    }
    int min_left(int p,int l,int r,int qr,int &s,int v){
        if(qr<l)return -1;
        if(r<=qr){
            int tmp=s+tr[p].val;
            if(tmp<v){
                s=tmp;
                return -1;
            }
            if(l==r)return l;
        }
        int mid=(l+r)>>1,ret;
        // pushdown(p);
        ret=min_left(tr[p][1],mid+1,r,qr,s,v);
        if(ret!=-1)return ret;
        return min_left(tr[p][0],l,mid,qr,s,v);
    }
};