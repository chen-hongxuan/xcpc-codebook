struct PalindromeAutomaton{
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
  string str;
  int last,pool;
  void pam_init(){
    st={node(0,1),node(-1,1)};
    str.clear();
    last=0,pool=2;
  }
  PalindromeAutomaton(){pam_init();}
  PalindromeAutomaton(const string &x){
    construct(x);
  }
  int getfail(int p,int x){
    while(x-st[p].len-1<0||
      str[x]!=str[x-st[p].len-1]){
      p=st[p].fail;
    }
    return p;
  }
  void extend(char x){
    int c=x-'a',pos=str.size();
    str.push_back(x);
    int p=getfail(last,pos),cur=st[p][c];
    if(!~cur){
      cur=pool++;
      st.emplace_back(st[p].len+2);
      if(st[cur].len==1){
        st[cur].fail=0;
      }else{
        int q=getfail(st[p].fail,pos);
        st[cur].fail=st[q][c];
      }
      st[p][c]=cur;
    }
    last=cur;
  }
  int construct(const string &x){
    pam_init();
    st.reserve(x.size()+2);
    str.reserve(x.size());
    for(char ch:x)extend(ch);
    return last;
  }
}pam;
