struct segmenttree2{
  struct node{
    array<int,2>ch{};
    int val=0;
    int &operator[](size_t i){return ch[i];}
  };
  vector<node> tr;
  int L,R;
  segmenttree2(int l=0,int r=0,int n=0):L(l),R(r){
    tr.reserve(n+1);
    tr.emplace_back();
  }
  void reserve(int n){tr.reserve(n+1);}
  int create(){
    tr.emplace_back();
    return tr.size()-1;
  }
  int val(int p){return p?tr[p].val:0;}
  void pushup(int p){
    tr[p].val=val(tr[p][0])+val(tr[p][1]);
  }
  int modify(int p,int l,int r,int x,int d){
    if(!p)p=create();
    if(l==r)tr[p].val+=d;
    else{
      int mid=(l+r)>>1;
      if(x<=mid){
        int q=modify(tr[p][0],l,mid,x,d);
        tr[p][0]=q;
      }else{
        int q=modify(tr[p][1],mid+1,r,x,d);
        tr[p][1]=q;
      }
      pushup(p);
    }
    return p;
  }
  int query(int p,int l,int r,int x,int y){
    if(!p||y<l||r<x)return 0;
    if(x<=l&&r<=y)return tr[p].val;
    int mid=(l+r)>>1,ret=0;
    if(l<=mid)ret+=query(tr[p][0],l,mid,x,y);
    if(mid<r)ret+=query(tr[p][1],mid+1,r,x,y);
    return ret;
  }
  int find(int p,int k){
    if(k<=0||val(p)<k)return -1;
    int l=L,r=R;
    while(l<r){
      int mid=(l+r)>>1,v=val(tr[p][0]);
      if(k<=v){
        p=tr[p][0];
        r=mid;
      }else{
        k-=v;
        p=tr[p][1];
        l=mid+1;
      }
    }
    return l;
  }
  int merge(int p,int q,int l,int r){
    if(!p||!q)return p|q;
    if(l==r)tr[p].val+=tr[q].val;
    else{
      int mid=(l+r)>>1;
      tr[p][0]=merge(tr[p][0],tr[q][0],l,mid);
      tr[p][1]=merge(tr[p][1],tr[q][1],mid+1,r);
      pushup(p);
    }
    return p;
  }
  void merge(int &p,int &q){
    p=merge(p,q,L,R);
    q=0;
  }
  array<int,2> split(int q,int l,int r,int x){
    if(!q)return {0,0};
    if(x<=l)return {0,q};
    if(r<x)return {q,0};
    int mid=(l+r)>>1;
    int ql=tr[q][0],qr=tr[q][1];
    auto a=split(ql,l,mid,x);
    auto b=split(qr,mid+1,r,x);
    int p=0,nq=0;
    if(a[0]||b[0]){
      nq=q;
      tr[nq][0]=a[0],tr[nq][1]=b[0];
      pushup(nq);
    }
    if(a[1]||b[1]){
      p=create();
      tr[p][0]=a[1],tr[p][1]=b[1];
      pushup(p);
    }
    return {nq,p};
  }
  void split(int &p,int &q,int x){
    auto [a,b]=split(q,L,R,x);
    q=a,p=b;
  }
  int split(int &q,int x){
    int p;
    split(p,q,x);
    return p;
  }
};