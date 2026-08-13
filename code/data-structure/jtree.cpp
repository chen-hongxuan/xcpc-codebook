struct ChairmanTree{
  struct node{
    array<int,2> ch;
    int val;
    node(int l=0,int r=0,int v=0):ch{l,r},val(v){}
    int &operator[](size_t i){return ch[i];}
  };
  vector<node> tr;
  VI root;
  ChairmanTree():tr(1),root{0}{}
  int clone(int q){
    tr.push_back(tr[q]);
    return tr.size()-1;
  }
  int val(int p,int q=0){
    return tr[p].val-tr[q].val;
  }
  void pushup(int p){
    tr[p].val=tr[tr[p][0]].val+tr[tr[p][1]].val;
  }
  int modify(int p,int l,int r,int x,int d){
    if(x<l||r<x)return p;
    int q=clone(p);
    if(l==r){
      tr[q].val+=d;
      return q;
    }else{
      int mid=(l+r)>>1;
      if(x<=mid){
        tr[q][0]=modify(tr[p][0],l,mid,x,d);
      }else{
        tr[q][1]=modify(tr[p][1],mid+1,r,x,d);
      }
      pushup(q);
      return q;
    }
  }
  int query(int p,int q,int l,int r,int L,int R){
    // 求第p个版本-第q个版本的[L,R]之间的和
    if(L<=l&&r<=R)return val(p,q);
    if(R<l||r<L||R<L)return 0;
    int ret=0,mid=(l+r)>>1;
    if(L<=mid){
      ret+=query(tr[p][0],tr[q][0],l,mid,L,R);
    }
    if(mid<R){
      ret+=query(tr[p][1],tr[q][1],mid+1,r,L,R);
    }
    return ret;
  }
  int kth(int p,int q,int l,int r,int k){
    if(l==r)return l;
    int mid=(l+r)>>1,bas=val(tr[p][0],tr[q][0]);
    if(k<=bas){
      return kth(tr[p][0],tr[q][0],l,mid,k);
    }else{
      return kth(tr[p][1],tr[q][1],mid+1,r,k-bas);
    }
  }
};