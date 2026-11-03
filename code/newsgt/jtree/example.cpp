//每个对象是一个版本, 无须提前 build
SegmentTree::clear();
vector<SegmentTree> v;
v.emplace_back(1,10);           //v[0] 是空版本
v.push_back(v.back().jmodify(3,1));
v.push_back(v.back().jmodify(7,1));
write(v[2].jquery(v[0],1,10),' ');//2
write(v[2].kth(v[0],2),'\n');    //7
//从任意历史版本派生, 原版本保持不变
auto b=v[1].jmodify(2,1);
write(v[1].query(1,10),' ');    //1
write(b.query(1,10),'\n');      //2
