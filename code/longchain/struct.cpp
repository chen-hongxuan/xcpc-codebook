struct LongChain{
  struct node{
    int val=-inf,tag=0;
  };
  struct chain{
    int b,s,l,w;
  };
  VI fa,h,son,ord,bel,off;
  vector<node> tr;
  vector<chain> c;

  void apply(int p,int v){
    if(tr[p].val==-inf)return;
    tr[p].val+=v,tr[p].tag+=v;
  }
  void pushup(int b,int p){
    tr[b+p].val=max(tr[b+(p<<1)].val,
                   tr[b+(p<<1|1)].val);
  }
  void pushdown(int b,int p){
    int t=tr[b+p].tag;
    if(!t)return;
    apply(b+(p<<1),t),apply(b+(p<<1|1),t);
    tr[b+p].tag=0;
  }
  void put(int p,int pos,int v){
    chmax(tr[p].val,v);
    tr[p].tag=0;
  }
  void inherit(int u){
    off[u]=son[u]?off[son[u]]:0;
  }
  void shift(int u,int d){off[u]+=d;}
  void add(int u,int v){apply(c[bel[u]].b+1,v);}
  int all(int u){return tr[c[bel[u]].b+1].val;}
  //剩余功能在以下的空间内实现

};
