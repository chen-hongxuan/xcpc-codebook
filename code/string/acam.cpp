struct ACAutomaton{
    vector<array<int,26>> trie;
    VI fail,cnt;
    int pool;
    void init(){
        fail=cnt={};
        trie={{}};
        pool=1;
    }
    int newnode(){
        trie.push_back({});
        cnt.push_back(0);
        return pool++;
    }
    int insert(string &str){
        int p=0;
        for(int ch:str){
            if(!trie[p][ch-'a']){
                trie[p][ch-'a']=newnode();
            }
            p=trie[p][ch-'a'];
        }
        ++cnt[p];
        return p;
    }
    void construct(){
        queue<int> q;
        for(int i=0;i<26;++i){
            if(trie[0][i])q.push(trie[0][i]);
        }
        fail.assign(pool,0);
        while(q.size()){
            int u=q.front();
            q.pop();
            for(int i=0;i<26;++i){
                int &v=trie[u][i];
                if(v){
                    fail[v]=trie[fail[u]][i];
                    q.push(v);
                }else{
                    v=trie[fail[u]][i];
                }
            }
        }
    }
}acam;