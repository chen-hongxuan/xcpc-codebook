struct SegmentTree{
  struct node{
    array<signed,2> ch{};
    int val=0,tag=0,l,r;
    node(int x=0,int y=0,signed u=0,signed v=0){
      l=x,r=y,ch[0]=u,ch[1]=v;
    }
    signed &operator[](size_t id){return ch[id];}
  };
  vector<node> tr;
  vector<signed> rootlist;
  signed pool,root;
  SegmentTree(int l=0,int r=0){
    rootlist={root=pool=1};
    tr={node(),node(l,r)};
  }
  signed newnode(int l,int r,signed u=0,signed v=0){
    tr.push_back(node(l,r,u,v));
    return ++pool;
  }
  signed &lc(signed p){return tr[p][0];}
  signed &rc(signed p){return tr[p][1];}
  void pushup(signed p){
    auto &LL=tr[lc(p)],&RR=tr[rc(p)];
    tr[p].val=LL.val+RR.val;
  }
  void pushdown(signed p){
    //TODO
  }
  //剩余功能在以下的空间内实现

};