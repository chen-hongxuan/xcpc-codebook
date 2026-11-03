struct SegmentTree{
  using sgt=SegmentTree;
  struct node{
    array<signed,2> ch{};
    int val=0,tag=0,l,r;
    node(int x=0,int y=0,signed u=0,signed v=0){
      l=x,r=y,ch[0]=u,ch[1]=v;
    }
    signed &operator[](size_t i){return ch[i];}
  };
  inline static vector<node> tr={node(0,0,0,0)};
  inline static signed pool=0;
  int L,R;
  signed root=0;
  SegmentTree(int l=0,int r=0):L(l),R(r){
    assert(l<=r);
  }
  SegmentTree(const sgt &)=delete;
  sgt &operator=(const sgt &)=delete;
  SegmentTree(sgt &&b)noexcept:
  L(b.L),R(b.R),root(exchange(b.root,0)){}
  sgt &operator=(sgt &&b)noexcept{
    if(this!=&b)L=b.L,R=b.R,root=exchange(b.root,0);
    return *this;
  }
  static void clear(){
    tr={node()},pool=0;
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
    //仅单点加时无须下传, 扩展懒标记时在此补充
  }
  //剩余功能在以下的空间内实现

};
