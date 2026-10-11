struct chain{
  int l,w;
};
VI off;
vector<chain> c;

void inherit(int u){
  off[u]=son[u]?off[son[u]]:0;
}
void shift(int u,int d){off[u]+=d;}
int pos(int u,int x){
  return x-off[u]-c[bel[u]].l;
}
array<int,2> range(int u,int L,int R){
  int l=pos(u,L),r=pos(u,R),w=c[bel[u]].w;
  return {max<int>(l,0),min(r,w-1)};
}
