struct SuffixAutomaton{
    struct node{
        array<int,26> ch;
        int len,fail;
        node(int l=0,int f=0):len(l),fail(f){
            ch.fill(-1);
        }
        int &operator[](size_t i){
            return ch[i];
        }
    };
    vector<node> st;
    int last,pool;
    void sam_init(){
        st={node(0,-1)};
        last=0,pool=1;
    }
    SuffixAutomaton(){sam_init();}
    SuffixAutomaton(string &x){
        construct(x);
    }
    void extend(char x){
        int c=x-'a',p=last,cur=pool++;
        st.emplace_back(st[p].len+1);
        for(;~p&&!~st[p][c];p=st[p].fail){
            st[p][c]=cur;
        }
        if(~p){
            int q=st[p][c];
            if(st[p].len+1==st[q].len){
                st[cur].fail=q;
            }else{
                int clone=pool++;
                st.push_back(st[q]);
                st[clone].len=st[p].len+1;
                for(;~p&&st[p][c]==q;p=st[p].fail){
                    st[p][c]=clone;
                }
                st[cur].fail=st[q].fail=clone;
            }
        }
        last=cur;
    }
    int construct(string &str){
        sam_init();
        for(int ch:str)extend(ch);
        return last;
    }
}sam;