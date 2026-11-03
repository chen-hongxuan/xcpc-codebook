//组合主体、build、单点加和 query, 放入 solve()
SegmentTree::clear();
SegmentTree a(1,10);
a.build();
a.modify(3,5);
a.modify(7,2);
write(a.query(1,10),'\n');  //7
