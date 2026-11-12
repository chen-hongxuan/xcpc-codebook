LiChaoSegmentTree t(1,10);
t.insert(1,2,3,4);
auto [y,id]=t.query(2); // y=3
t.insert(Line(2,1)); // 整个值域内的 y=2x+1
t.insert(Line(-1,8),2,6); // 仅在 [2,6] 有效
LiChaoSegmentTree s(1,10);
s.insert(Line(0,20),4,6);
t.merge(s); // s 变为空树，t.query(5).first=20
