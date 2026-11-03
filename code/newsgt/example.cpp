//放入基础模板的 solve() 中
SegmentTree::clear();
SegmentTree a(1,10),b(1,10);
a.insert(3,5);
b.insert(7,2);
a.merge(b);                //a: {3:5,7:2}, b 为空
auto c=a.split(5);         //a 保留 <5, c 得到 >=5
write(a.query(1,10),' ');   //5
write(c.query(1,10),'\n');  //2
b.insert(1,4);             //合并后仍可重新插入
//c 变空, d 接管它的根
SegmentTree d=move(c);
write(d.query(1,10),'\n');  //2
