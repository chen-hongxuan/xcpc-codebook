struct FHQtreap{
    struct node{
        array<int,2>ch;
        int val,siz,key;
        node(int v=0,int k=0,int s=0):ch{},val(v),siz(s),key(k){}
        int &operator[](size_t i){return ch[i];}
    };
    vector<node>tr;
    int root;
    mt19937 rnd;
    FHQtreap(int n=0):root(0),rnd(time(0)){
        tr.reserve(n+1);
        tr.emplace_back();
    }
    int size(int p)const{return tr[p].siz;}
    int size()const{return size(root);}
    bool empty()const{return !root;}
    void reserve(int n){tr.reserve(n+1);}
    void clear(){
        tr.resize(1);
        tr[0]=node();
        root=0;
    }
    int create(int x){
        tr.emplace_back(x,rnd(),1);
        return tr.size()-1;
    }
    void update(int p){
        if(p)tr[p].siz=size(tr[p][0])+size(tr[p][1])+1;
    }
    void split(int p,int d,int &x,int &y,int opt=0){
        if(!p){
            x=y=0;
            return;
        }
        if(tr[p].val<d||(opt&&tr[p].val==d)){
            x=p;
            split(tr[p][1],d,tr[p][1],y,opt);
        }else{
            y=p;
            split(tr[p][0],d,x,tr[p][0],opt);
        }
        update(p);
    }
    int merge(int x,int y){
        if(!x||!y)return x|y;
        if(tr[x].key>tr[y].key){
            tr[x][1]=merge(tr[x][1],y);
            update(x);
            return x;
        }else{
            tr[y][0]=merge(x,tr[y][0]);
            update(y);
            return y;
        }
    }
    void insert(int d){
        int x,y,p=create(d);
        split(root,d,x,y);
        root=merge(merge(x,p),y);
    }
    bool remove(int d){
        int x,y,z;
        split(root,d,x,y);//x<d，y>=d
        split(y,d,z,y,1);//z==d，y>d
        if(!z){
            root=merge(x,y);
            return false;
        }
        z=merge(tr[z][0],tr[z][1]);
        root=merge(merge(x,z),y);
        return true;
    }
    int rank(int d){
        int p=root,ret=1;
        while(p){
            if(tr[p].val<d){
                ret+=size(tr[p][0])+1;
                p=tr[p][1];
            }else p=tr[p][0];
        }
        return ret;
    }
    int kth(int k){
        assert(1<=k&&k<=size());
        int p=root;
        while(p){
            int ls=size(tr[p][0]);
            if(k==ls+1)return tr[p].val;
            if(k<=ls)p=tr[p][0];
            else{
                k-=ls+1;
                p=tr[p][1];
            }
        }
        return 0;
    }
    int pre(int d){
        int p=root,ret=0;
        while(p){
            if(tr[p].val<d){
                ret=p;
                p=tr[p][1];
            }else p=tr[p][0];
        }
        assert(ret);
        return tr[ret].val;
    }
    int nxt(int d){
        int p=root,ret=0;
        while(p){
            if(tr[p].val>d){
                ret=p;
                p=tr[p][0];
            }else p=tr[p][1];
        }
        assert(ret);
        return tr[ret].val;
    }
};