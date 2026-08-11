#include <bits/stdc++.h>
using namespace std;
#define VI vector<int>
const int inf=1e18;
namespace spfa{
    int work(int n,VI &s,vector<vector<array<int,2>>> &edge,VI &dis){
        queue<int> q;
        dis.assign(n+5,inf);
        VI vis(n+5,0),cnt(n+5,0);
        for(int x:s){
            dis[x]=0;
            vis[x]=1;
            q.push(x);
        }
        while(q.size()){
            int u=q.front();
            q.pop(),vis[u]=0;
            for(auto [v,w]:edge[u]){
                if(dis[v]>dis[u]+w){
                    dis[v]=dis[u]+w;
                    cnt[v]=cnt[u]+1;
                    if(cnt[v]>=n)return 1;
                    if(!vis[v]){
                        vis[v]=1;
                        q.push(v);
                    }
                }
            }
        }
        return 0;
    }
}