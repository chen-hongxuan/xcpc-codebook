struct LiChaoSegmentTree{
  struct line{
    int x,y,dx,dy;
    __int128 num(const int t)const{
      return (__int128)y*dx+(__int128)dy*(t-x);
    }
  };
  struct node{
    array<signed,2> ch{};
    int id=0;
  };
  vector<node> tr={{}};
  vector<line> seg={{}};
  int L,R;
  signed root=0;
  LiChaoSegmentTree(const int l,const int r):L(l),R(r){
    assert(l<=r);
  }
  signed newnode(const int id=0){
    tr.push_back({{},id});
    return tr.size()-1;
  }
  bool better(const int u,const int v,const int x)const{
    if(!u||!v)return u>v;
    const line &a=seg[u],&b=seg[v];
    __int128 A=a.num(x)*b.dx,B=b.num(x)*a.dx;
    return A!=B?A>B:u<v;
  }
  signed add(const signed p,const int l,const int r,int u){
    if(!p)return newnode(u);
    int m=l+(r-l)/2;
    if(better(u,tr[p].id,m))swap(u,tr[p].id);
    if(!u||l==r)return p;
    int v=tr[p].id;
    if(better(u,v,l))tr[p].ch[0]=add(tr[p].ch[0],l,m,u);
    else if(better(u,v,r))tr[p].ch[1]=add(tr[p].ch[1],m+1,r,u);
    return p;
  }
  signed insert(signed p,const int l,const int r,
                const int ql,const int qr,const int id){
    if(qr<l||r<ql)return p;
    if(ql<=l&&r<=qr)return add(p,l,r,id);
    if(!p)p=newnode();
    int m=l+(r-l)/2;
    tr[p].ch[0]=insert(tr[p].ch[0],l,m,ql,qr,id);
    tr[p].ch[1]=insert(tr[p].ch[1],m+1,r,ql,qr,id);
    return p;
  }
  int insert(int xa,int ya,int xb,int yb){
    if(xa>xb){
      swap(xa,xb);
      swap(ya,yb);
    }
    int dx=xb-xa,id=seg.size();
    if(dx==0)seg.push_back({xa,max(ya,yb),1,0});
    else seg.push_back({xa,ya,dx,yb-ya});
    root=insert(root,L,R,xa,xb,id);
    return id;
  }
  pair<ld,int> query(const int x)const{
    if(x<L||x>R)return {-finf,0};
    int u=0,l=L,r=R;
    for(signed p=root;p;){
      if(better(tr[p].id,u,x))u=tr[p].id;
      if(l==r)break;
      int m=l+(r-l)/2;
      if(x<=m)p=tr[p].ch[0],r=m;
      else p=tr[p].ch[1],l=m+1;
    }
    if(!u)return {-finf,0};
    return {(ld)seg[u].num(x)/seg[u].dx,u};
  }
};
