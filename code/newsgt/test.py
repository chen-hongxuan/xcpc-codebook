#!/usr/bin/env python3
"""Assemble the segment-tree fragments and check them against plain arrays."""

import os
from pathlib import Path
import random
import subprocess
import tempfile


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]

CHECKS = r'''
using Tree=SegmentTree;
static_assert(!is_copy_constructible_v<Tree>);
static_assert(!is_copy_assignable_v<Tree>);
static_assert(is_nothrow_move_constructible_v<Tree>);
static_assert(is_nothrow_move_assignable_v<Tree>);

void example(){
EXAMPLE
}

void normal_example(){
NORMAL_EXAMPLE
}

void persistent_example(){
PERSISTENT_EXAMPLE
}

void ordinary(){
  Tree::clear();
  const int lo=-16,hi=15;
  Tree a(lo,hi),b(lo,hi);
  a.build(),b.build();
  assert(a.root&&b.root&&a.root!=b.root);
  VI v(hi-lo+1),w(hi-lo+1);
  mt19937_64 rng(701);
  for(int step=0;step<1000;++step){
    int x=rng()%v.size(),y=rng()%w.size();
    a.modify(x+lo,1),++v[x];
    b.insert(y+lo,2),w[y]+=2;
    int l=lo+rng()%v.size(),r=lo+rng()%v.size(),sum=0;
    for(int j=l;j<=r;++j)sum+=v[j-lo];
    assert(a.query(l,r)==sum);
  }
  for(int step=0;step<500;++step){
    int ql=lo+rng()%v.size(),qr=lo+rng()%v.size(),limit=rng()%1200;
    int r=ql-1,sum=0;
    while(r<hi&&sum+v[r+1-lo]<=limit)sum+=v[++r-lo];
    int s=0;
    assert(a.max_Right(a.root,ql,s,limit)==r&&s==sum);
    int l=qr+1;
    sum=0;
    while(l>lo&&sum+v[l-1-lo]<=limit)sum+=v[--l-lo];
    s=0;
    assert(a.min_Left(a.root,qr,s,limit)==l&&s==sum);
  }
  a.merge(b);
  assert(!b.root);
  auto right=a.split(0);
  for(int x=lo;x<=hi;++x){
    int value=v[x-lo]+w[x-lo];
    assert(a.query(x,x)==(x<0?value:0));
    assert(right.query(x,x)==(x>=0?value:0));
  }
  b.build();
  b.modify(lo,7);
  assert(b.query(lo,hi)==7);
}

void persistent(){
  Tree::clear();
  Tree seg(1,64);
  seg.build();
  vector<signed> rt={seg.root};
  VVI values(1,VI(65));
  mt19937_64 rng(1703);
  for(int step=0;step<300;++step){
    int parent=rng()%rt.size(),x=1+rng()%64;
    rt.push_back(seg.jmodify(rt[parent],x,1));
    values.push_back(values[parent]);
    ++values.back()[x];
    assert(seg.kth(rt.back(),rt[parent],1)==x);
    assert(seg.kth(rt.back(),rt[parent],2)==-1);
    for(int j=0;j<10;++j){
      int p=rng()%rt.size(),q=rng()%rt.size();
      int l=1+rng()%64,r=1+rng()%64,sum=0;
      for(int k=l;k<=r;++k)sum+=values[p][k]-values[q][k];
      assert(seg.jquery(rt[p],rt[q],l,r)==sum);
      assert(seg.jquery(rt[p],0,1,64)==accumulate(values[p].begin(),values[p].end(),0LL));
    }
    int k=1;
    for(int i=1;i<=64;++i)for(int c=0;c<values.back()[i];++c)
      assert(seg.kth(rt.back(),k++)==i);
    assert(seg.kth(rt.back(),0)==-1&&seg.kth(rt.back(),k)==-1);
    assert(seg.query(1,64)==0);
  }
  for(int p=0;p<rt.size();++p)for(int x=1;x<=64;++x)
    assert(seg.jquery(rt[p],0,x,x)==values[p][x]);
}

void unchanged(const vector<Tree::node> &before){
  assert(Tree::tr.size()>=before.size());
  for(int i=0;i<before.size();++i){
    const auto &a=before[i],&b=Tree::tr[i];
    assert(a.ch==b.ch&&a.val==b.val&&a.tag==b.tag);
    assert(a.l==b.l&&a.r==b.r);
  }
}

void persistent_objects(){
  Tree::clear();
  const int lo=-20,hi=20;
  vector<Tree> versions;
  versions.emplace_back(lo,hi);
  VVI values(1,VI(hi-lo+1));
  assert(!versions[0].root&&Tree::pool==0);
  assert(versions[0].jquery(versions[0],lo,hi)==0);
  assert(versions[0].kth(1)==-1);
  mt19937_64 rng(713);
  for(int step=0;step<1000;++step){
    int parent=rng()%versions.size();
    int x=lo-2+rng()%(hi-lo+5),d=(int)(rng()%7)-3;
    auto before=Tree::tr;
    signed count=Tree::pool,root=versions[parent].root;
    versions.push_back(versions[parent].jmodify(x,d));
    values.push_back(values[parent]);
    if(lo<=x&&x<=hi){
      values.back()[x-lo]+=d;
      assert(Tree::pool-count>=1&&Tree::pool-count<=7);
      assert(versions.back().root!=root);
    }else{
      assert(Tree::pool==count&&versions.back().root==root);
    }
    assert(versions[parent].root==root);
    assert(versions.back().L==lo&&versions.back().R==hi);
    unchanged(before);
    count=Tree::pool;
    auto readonly=Tree::tr;
    if(lo<=x&&x<=hi&&d>0){
      assert(versions.back().kth(versions[parent],1)==x);
      assert(versions.back().kth(versions[parent],d)==x);
      assert(versions.back().kth(versions[parent],d+1)==-1);
    }
    for(int j=0;j<8;++j){
      int p=rng()%versions.size(),q=rng()%versions.size();
      int l=lo-2+rng()%(hi-lo+5),r=lo-2+rng()%(hi-lo+5);
      int sum=0,single=0;
      for(int i=max(l,lo);i<=min(r,hi);++i){
        sum+=values[p][i-lo]-values[q][i-lo];
        single+=values[p][i-lo];
      }
      assert(versions[p].jquery(versions[q],l,r)==sum);
      assert(versions[p].query(l,r)==single);
      assert(versions[p].kth(versions[p],1)==-1);
    }
    assert(Tree::pool==count&&Tree::tr.size()==readonly.size());
    unchanged(readonly);
  }
  for(int p=0;p<versions.size();++p){
    for(int x=lo;x<=hi;++x)
      assert(versions[p].query(x,x)==values[p][x-lo]);
  }
}

void persistent_prefix(){
  Tree::clear();
  const int n=200,m=17;
  vector<Tree> versions;
  versions.emplace_back(1,m);
  VI data;
  mt19937_64 rng(117);
  for(int i=0;i<n;++i){
    int x=1+rng()%m;
    data.push_back(x);
    versions.push_back(versions.back().jmodify(x,1));
  }
  auto before=Tree::tr;
  signed count=Tree::pool;
  for(int i=0;i<2000;++i){
    int l=1+rng()%n,r=1+rng()%n;
    if(l>r)swap(l,r);
    VI sub(data.begin()+l-1,data.begin()+r);
    sort(sub.begin(),sub.end());
    int k=1+rng()%sub.size();
    assert(versions[r].kth(versions[l-1],k)==sub[k-1]);
    assert(versions[r].kth(versions[l-1],0)==-1);
    assert(versions[r].kth(versions[l-1],sub.size()+1)==-1);
    assert(versions[r].jquery(versions[l-1],1,m)==sub.size());
    int a=(int)(rng()%(m+4))-1,b=(int)(rng()%(m+4))-1,sum=0;
    for(int x:sub)sum+=a<=x&&x<=b;
    assert(versions[r].jquery(versions[l-1],a,b)==sum);
    VI prefix(data.begin(),data.begin()+r);
    sort(prefix.begin(),prefix.end());
    k=1+rng()%prefix.size();
    assert(versions[r].kth(k)==prefix[k-1]);
  }
  assert(Tree::pool==count);
  unchanged(before);
}

void persistent_boundaries(){
  Tree::clear();
  Tree empty(-1000000000,1000000000);
  auto a=empty.jmodify(-1000000000,1LL<<35);
  assert(Tree::pool<=32&&!empty.root);
  signed count=Tree::pool;
  auto b=a.jmodify(1000000000,1LL<<35);
  assert(Tree::pool-count<=32);
  assert(a.query(-1000000000,1000000000)==(1LL<<35));
  assert(b.jquery(a,-1000000000,1000000000)==(1LL<<35));
  assert(b.kth(empty,1)==-1000000000);
  assert(b.kth(empty,(1LL<<35)+1)==1000000000);
  auto moved=move(b);
  assert(!b.root&&moved.query(-1000000000,1000000000)==(1LL<<36));
  auto branch=b.jmodify(0,1);
  assert(branch.kth(1)==0&&!b.root);
  Tree one(7,7);
  auto negative=one.jmodify(7,-5);
  auto positive=negative.jmodify(7,8);
  assert(!one.root&&negative.query(7,7)==-5&&positive.query(7,7)==3);
  assert(positive.kth(one,3)==7&&positive.kth(4)==-1);
  assert(negative.jquery(positive,7,7)==-8);
  Tree raw(-4,4);
  signed p=raw.jmodify(0,0,3);
  signed q=raw.jmodify(p,-4,2);
  assert(!raw.root&&raw.jquery(p,0,-4,4)==3);
  assert(raw.jquery(q,p,-4,4)==2&&raw.kth(q,p,1)==-4);
}

void longchain_compatibility(){
  Tree::clear();
  int n=11;
  VVI edge(n+1);
  VI parent(n+1),A(n+1),B(n+1);
  for(int u=2;u<=n;++u){
    parent[u]=u/2;
    edge[u].push_back(parent[u]);
    edge[parent[u]].push_back(u);
  }
  for(int u=1;u<=n;++u)A[u]=u%3-1,B[u]=A[u]+2;
LONGCHAIN_EXAMPLE
  for(int u=1;u<=n;++u){
    int expected=0;
    for(int x=1;x<=n;++x){
      int v=x,distance=0;
      while(v&&v!=u)v=parent[v],++distance;
      if(v==u&&A[u]<=distance&&distance<=B[u])++expected;
    }
    assert(ans[u]==expected);
  }
}

void boundaries(){
  Tree::clear();
  for(int x=-2;x<=10;++x){
    Tree a(0,8);
    assert(a.root==0&&a.query(-10,10)==0);
    signed p=Tree::pool;
    a.insert(-1,5),a.insert(9,5);
    assert(!a.root&&Tree::pool==p);
    for(int i=0;i<=8;++i)a.insert(i,i-3);
    auto b=a.split(x);
    assert(a.L==0&&a.R==8&&b.L==0&&b.R==8);
    for(int i=0;i<=8;++i){
      assert(a.query(i,i)==(i<x?i-3:0));
      assert(b.query(i,i)==(i>=x?i-3:0));
    }
    p=Tree::pool;
    a.merge(b);
    assert(!b.root&&Tree::pool==p);
    for(int i=0;i<=8;++i)assert(a.query(i,i)==i-3);
    b.insert(4,7);
    assert(b.query(0,8)==7&&a.query(4,4)==1);
    Tree c=move(a);
    assert(!a.root&&c.query(0,8)==9);
    a.insert(2,11);
    assert(a.query(0,8)==11&&c.query(2,2)==-1);
    a=move(c);
    assert(!c.root&&a.query(0,8)==9);
    a=move(a);
    assert(a.query(0,8)==9);
    assert(a.query(5,4)==0);
  }
  Tree empty(-5,5),other(-5,5);
  auto part=empty.split(0);
  empty.merge(other);
  assert(!empty.root&&!other.root&&!part.root);
  Tree one(-1,-1);
  one.insert(-1,1LL<<50);
  auto right=one.split(-1);
  assert(!one.root&&right.query(-1,-1)==(1LL<<50));
}

void walk(Tree &t,signed p,int l,int r,set<signed> &seen){
  if(!p)return;
  assert(p>0&&p<=Tree::pool&&seen.insert(p).second);
  auto &v=Tree::tr[p];
  assert(v.l==l&&v.r==r);
  if(l==r){
    assert(!v[0]&&!v[1]);
    return;
  }
  int mid=(l+r)>>1;
  walk(t,v[0],l,mid,seen);
  walk(t,v[1],mid+1,r,seen);
  assert(v.val==Tree::tr[v[0]].val+Tree::tr[v[1]].val);
}

void check(vector<Tree> &trees,VVI &values,int lo,int hi){
  assert(Tree::tr.size()==Tree::pool+1);
  assert(!Tree::tr[0].val&&!Tree::tr[0][0]&&!Tree::tr[0][1]);
  set<signed> seen;
  for(int i=0;i<trees.size();++i){
    auto &t=trees[i];
    assert(t.L==lo&&t.R==hi);
    int sum=0;
    for(int x=lo;x<=hi;++x){
      assert(t.query(x,x)==values[i][x-lo]);
      sum+=values[i][x-lo];
    }
    assert(t.query(lo-5,hi+5)==sum);
    walk(t,t.root,lo,hi,seen);
  }
}

void randomized(){
  Tree::clear();
  const int lo=-32,hi=31,n=12;
  vector<Tree> trees;
  VVI values(n,VI(hi-lo+1));
  for(int i=0;i<n;++i){
    trees.emplace_back(lo,hi);
    trees.back().insert(lo+i,i+1);
    values[i][i]=i+1;
  }
  check(trees,values,lo,hi);
  mt19937_64 rng(20261103);
  auto pick=[&](int n){return (int)(rng()%n);};
  for(int step=0;step<25000;++step){
    int a=pick(n),b=pick(n-1);
    if(b>=a)++b;
    switch(pick(7)){
      case 0:{
        int x=lo-2+pick(hi-lo+5),d=pick(21)-10;
        trees[a].insert(x,d);
        if(lo<=x&&x<=hi)values[a][x-lo]+=d;
        break;
      }
      case 1:{
        int l=lo-2+pick(hi-lo+5),r=lo-2+pick(hi-lo+5),sum=0;
        for(int x=max(l,lo);x<=min(r,hi);++x)sum+=values[a][x-lo];
        assert(trees[a].query(l,r)==sum);
        break;
      }
      case 2:{
        signed p=Tree::pool;
        trees[a].merge(trees[b]);
        assert(!trees[b].root&&Tree::pool==p);
        for(int i=0;i<values[a].size();++i)values[a][i]+=values[b][i];
        fill(values[b].begin(),values[b].end(),0);
        break;
      }
      case 3:{
        int x=lo-2+pick(hi-lo+5);
        signed p=Tree::pool;
        trees[b]=trees[a].split(x);
        assert(Tree::pool-p<=7);
        fill(values[b].begin(),values[b].end(),0);
        for(int i=0;i<values[a].size();++i)if(i+lo>=x){
          values[b][i]=values[a][i];
          values[a][i]=0;
        }
        break;
      }
      case 4:{
        trees[b]=move(trees[a]);
        assert(!trees[a].root);
        values[b]=values[a];
        fill(values[a].begin(),values[a].end(),0);
        break;
      }
      case 5:swap(trees[a],trees[b]),swap(values[a],values[b]);break;
      case 6:trees[a]=move(trees[a]);break;
    }
    if(step%250==0)check(trees,values,lo,hi);
  }
  check(trees,values,lo,hi);
}

void wide_domain(){
  Tree::clear();
  Tree a(-1000000000,1000000000);
  map<int,int> values;
  mt19937_64 rng(17);
  for(int i=0;i<1000;++i){
    int x=(int)(rng()%2000000001)-1000000000;
    a.insert(x,1LL<<35),values[x]+=1LL<<35;
  }
  auto b=a.split(0);
  int left=0,right=0;
  for(auto [x,v]:values){
    assert((x<0?a:b).query(x,x)==v);
    (x<0?left:right)+=v;
  }
  assert(a.query(-1000000000,1000000000)==left);
  assert(b.query(-1000000000,1000000000)==right);
  a.merge(b);
  assert(!b.root&&a.query(-1000000000,1000000000)==left+right);
}

signed main(){
  example();
  normal_example();
  persistent_example();
  ordinary();
  persistent();
  persistent_objects();
  persistent_prefix();
  persistent_boundaries();
  longchain_compatibility();
  boundaries();
  randomized();
  wide_domain();
  Tree::clear();
  assert(Tree::pool==0&&Tree::tr.size()==1);
  cout<<"newsgt: ordinary, sparse persistent, read-only queries, long-chain and 25000 random operations passed\n";
}
'''


def main():
    template = (ROOT / "code/basic/template.cpp").read_text()
    base = template.split("void solve(){")[0]
    members = "\n".join(
        (HERE / name).read_text()
        for name in (
            "normal/build.cpp", "normal/add.cpp", "normal/query.cpp",
            "normal/modify.cpp", "normal/max_Right.cpp", "normal/min_Left.cpp",
            "ins/insert.cpp", "ins/merge.cpp", "ins/split.cpp",
            "jtree/bas.cpp", "jtree/jmodify.cpp", "jtree/jquery.cpp", "jtree/kth.cpp",
        )
    )
    tree = (HERE / "struct.cpp").read_text().replace(
        "//剩余功能在以下的空间内实现", members
    )
    persistent_members = "\n".join(
        (HERE / name).read_text()
        for name in (
            "normal/query.cpp", "jtree/bas.cpp", "jtree/jmodify.cpp",
            "jtree/jquery.cpp", "jtree/kth.cpp",
        )
    )
    persistent_tree = (HERE / "struct.cpp").read_text().replace(
        "//剩余功能在以下的空间内实现", persistent_members
    )
    persistent_only = base + "\n" + persistent_tree + "\nsigned main(){\n" + (HERE / "jtree/example.cpp").read_text() + "\n}\n"
    subprocess.run([
        "g++", "-std=gnu++17", "-x", "c++", "-fsyntax-only", "-",
    ], input=persistent_only, text=True, check=True)
    longchain = ROOT / "code/longchain"
    chain = (longchain / "struct.cpp").read_text().replace(
        "//剩余功能在以下的空间内实现",
        "\n".join((longchain / name).read_text() for name in ("init.cpp", "index.cpp", "build.cpp")),
    )
    checks = CHECKS
    for marker, file in (
        ("NORMAL_EXAMPLE", HERE / "normal/example.cpp"),
        ("PERSISTENT_EXAMPLE", HERE / "jtree/example.cpp"),
        ("LONGCHAIN_EXAMPLE", longchain / "segment.cpp"),
        ("EXAMPLE", HERE / "example.cpp"),
    ):
        checks = checks.replace(marker, file.read_text())
    with tempfile.TemporaryDirectory(prefix="newsgt-test-") as temporary:
        source, executable = Path(temporary) / "test.cpp", Path(temporary) / "test"
        source.write_text(base + "\n" + tree + "\n" + chain + "\n" + checks)
        compiler = [
            "g++", "-std=gnu++17", "-O1", "-g", "-D_GLIBCXX_DEBUG",
            "-fno-elide-constructors", "-fsanitize=address,undefined",
            "-fno-sanitize-recover=all", "-fno-omit-frame-pointer",
        ]
        subprocess.run(compiler + [str(source), "-o", str(executable)], check=True)
        environment = dict(os.environ, ASAN_OPTIONS="detect_leaks=0")
        result = subprocess.run([
            str(executable),
        ], check=True, text=True, stdout=subprocess.PIPE, env=environment)
        expected = "5 2\n2\n7\n2 7\n1 2\nnewsgt: ordinary, sparse persistent, read-only queries, long-chain and 25000 random operations passed\n"
        assert result.stdout == expected, result.stdout
        print(result.stdout, end="")

        sample = Path(temporary) / "range-kth.cpp"
        sample_executable = Path(temporary) / "range-kth"
        solve = (HERE / "jtree/range-kth.cpp").read_text()
        sample.write_text(base + "\n" + persistent_tree + "\nvoid solve(){\n" + solve + "\n}\n" + template[template.index("signed main(){"):])
        subprocess.run(compiler + [str(sample), "-o", str(sample_executable)], check=True)
        cases = [
            ([9], []),
            ([-10**18], [(1, 1, 1)]),
            ([4, -2, 4, 0, -7], [(1, 5, k) for k in range(1, 6)] + [(2, 4, 2)]),
        ]
        rng = random.Random(1703)
        for _ in range(24):
            n = rng.randint(1, 35)
            values = [rng.choice([-10**18, -7, -1, 0, 2, 2, 10**18, rng.randint(-100, 100)]) for _ in range(n)]
            queries = []
            for _ in range(30):
                l = rng.randint(1, n)
                r = rng.randint(l, n)
                queries.append((l, r, rng.randint(1, r-l+1)))
            cases.append((values, queries))
        input_lines, answers = [str(len(cases))], []
        for values, queries in cases:
            input_lines.extend([f"{len(values)} {len(queries)}", " ".join(map(str, values))])
            for l, r, k in queries:
                input_lines.append(f"{l} {r} {k}")
                answers.append(str(sorted(values[l-1:r])[k-1]))
        result = subprocess.run([
            str(sample_executable),
        ], input="\n".join(input_lines)+"\n", text=True, stdout=subprocess.PIPE, check=True, env=environment)
        assert result.stdout.splitlines() == answers, result.stdout
        print(f"Range-kth solve() example: {len(cases)} cases / {len(answers)} queries passed")


if __name__ == "__main__":
    main()
