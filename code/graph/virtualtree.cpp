struct VirtualTree{
  function<int(int,int)> lca;
  VI dfn,dep;
  int root;
  template<class F>
  VirtualTree(VI &DFN,VI &DEP,F f,int rt){
    lca=f,dfn=DFN,dep=DEP,root=rt;
  }
  int work(VI Nd,vector<VI> &tree,VI &lnk){
    lnk={-1,root},tree={{},{}};
    VI stk={1};
    int top=0,pool=1;
    auto node=[&](int x){
      lnk.push_back(x);
      tree.push_back({});
      return ++pool;
    };
    auto insert=[&](int x){
      int p=node(x);
      if(!top){
        stk.push_back(p),++top;
        return;
      }
      int tmp=lca(x,lnk[stk[top]]);
      if(tmp==lnk[stk[top]]){
        stk.push_back(p),++top;
        return;
      }
      while(top&&dep[tmp]<dep[lnk[stk[top-1]]]){
        tree[stk[top-1]].push_back(stk[top]);
        stk.pop_back(),--top;
      }
      if(tmp==lnk[stk[top-1]]){
        tree[stk[top-1]].push_back(stk[top]);
        stk[top]=p;
        return;
      }
      int q=node(tmp);
      tree[q].push_back(stk[top]);
      stk[top]=q;
      stk.push_back(p),++top;
    };
    sort(Nd.begin(),Nd.end(),[&](int x,int y){
      return dfn[x]<dfn[y];
    });
    for(int x:Nd)if(x!=root)insert(x);
    while(top){
      tree[stk[top-1]].push_back(stk[top]);
      stk.pop_back(),--top;
    }
    return pool;
  }
};