#import "../common.typ": code-file, code-info as base-code-info

#let code-info(api, complexity) = {
  set par(leading: 0.35em)
  base-code-info(api, complexity)
}

= 计算几何

本章沿用基础模板中的 `ld`、`finf`、`chmin` 和 `chmax`。

== 基础元素

=== 向量

#code-info(
  [`vec(x,y)` 表示点或向量，`v.rot(t)` 逆时针旋转 $t$ 弧度。`dot`、`cross` 和 `dist` 分别求点积、叉积和两点距离。`chkside(x,y,a)` 返回 `1` 左侧、`-1` 右侧、`0` 共线。`chkinside(x,y,z,a)` 判断 `a` 是否在三角形 `xyz` 内或边界上。三点共线时按线段或点判定。],
  [各操作均为 $O(1)$。],
)
#code-file("code/geometry/struct.cpp", part: "vec")

=== 极角排序

#code-info(
  [`polarsort::porder(p)` 返回排序后的原下标，`polarsort::psort(p)` 返回排序后的向量。零向量在最前，其余从正 $x$ 轴起逆时针排列。同向时依次比较长度和原下标。],
  [$O(n log n)$ 时间，$O(n)$ 空间。],
)
#code-file("code/geometry/polar-sort.cpp")

=== 直线、射线、线段

#code-info(
  [`line{a,b,type}` 表示 $a+t(b-a)$，`type` 为 `0` 直线、`1` 射线、`2` 线段。`meet(x,y)` 返回 `0` 无交、`1` 单点相交、`2` 共线重叠。`intersect` 和 `proj` 使用所在直线，求交要求交点唯一。`distl` 按 `type` 求点到对象的最短距离。],
  [各操作均为 $O(1)$。],
)
#code-file("code/geometry/struct.cpp", part: "line")

== 多边形

各代码段按顺序组成 `polygon`。顶点沿简单多边形边界排列，首点存一次。

=== 求面积

#code-info(
  [`area()` 返回非负面积并缓存到 `S`。修改 `p` 后将 `viss` 和 `visc` 设回 `false`。],
  [首次 $O(n)$，读取缓存 $O(1)$。],
)
#code-file("code/geometry/polygon.cpp", part: "area")

=== 求周长

#code-info(
  [`perimeter()` 返回闭合边界的周长并缓存到 `C`。],
  [首次 $O(n)$，读取缓存 $O(1)$。],
)
#code-file("code/geometry/polygon.cpp", part: "perimeter")

=== 询问点是否在多边形内

#code-info(
  [`inside(x)` 用射线法返回 `0` 内部、`1` 边界、`2` 外部。],
  [$O(n)$ 时间，$O(1)$ 额外空间。],
)
#code-file("code/geometry/polygon.cpp", part: "inside")

== 凸包

===& 公共结构

#code-info(
  [`convex` 用 `p` 保存逆时针顶点序列，首点存一次，共线边只保留两端。将下面需要的成员函数片段放入本体预留位置。`sector(x,dir)` 是点内判定和切线共用的射线定位，返回所处扇形的起始下标，扇形外返回首边或尾边的下标，`dir=-1` 表示背向 `x` 的射线。],
  [存储空间 $O(h)$。射线定位 $O(log h)$，由相应查询在至少三个顶点时调用。],
)
#code-file("code/geometry/convex.cpp")

构造、点内判定、卡壳和切线可分别选用。查询使用 `construct` 得到的顶点序列，或自行提供满足本体约定的序列。

=== 构造

#code-info(
  [`construct(points)` 用 Andrew 单调链重建凸包。`p` 逆时针排列，首点存一次，共线边只保留两端。],
  [$O(n log n)$ 时间，$O(n)$ 空间。],
)
#code-file("code/geometry/convex/construct.cpp")

=== 询问点是否在凸包内

#code-info(
  [`inside(x)` 用扇形二分返回 `0` 内部、`1` 边界、`2` 外部。],
  [$O(log h)$ 时间，$O(1)$ 额外空间，$h$ 为凸包顶点数。],
)
#code-file("code/geometry/convex/inside.cpp")

=== 旋转卡壳

#code-info(
  [`calipers()` 或 `calipers(0)` 返回直径，即最远两点的欧氏距离；`calipers(1)` 返回最小外接矩形面积。空凸包和单点的直径为 `0`，少于三个顶点时矩形面积为 `0`。],
  [$O(h)$ 时间，$O(1)$ 额外空间。],
)
#code-file("code/geometry/convex/calipers.cpp")

=== 切线

#code-info(
  [`tangent(x)` 返回两个切点在 `p` 中的下标 `{l,r}`。沿 `x` 指向 `p[l]` 时，凸包位于左侧或线上。沿 `x` 指向 `p[r]` 时，凸包位于右侧或线上。切线贴边时取该边的一个端点。空凸包、内部点和边界点返回 `{-1,-1}`。退化凸包只有一条切线时返回相同下标。],
  [$O(log h)$ 时间，$O(1)$ 额外空间。依赖本体的 `sector`。],
)
#code-file("code/geometry/convex/tangent.cpp")

=== 闵可夫斯基和

#code-info(
  [`Minkowski::work(x,y)` 返回两个凸包中所有点两两相加形成的凸包。输入满足公共结构的顶点约定，支持空集、点和线段；任一输入为空时返回空凸包。本段放在 `convex` 结构体外，仅依赖公共结构和向量运算。],
  [$O(n+m)$ 时间，结果占用 $O(n+m)$ 空间，$n,m$ 为两个凸包的顶点数。],
)
#code-file("code/geometry/convex/minkowski.cpp")

===& 使用示例

将四个成员模块放入本体，`Minkowski` 命名空间放在结构体外。`points`、`points2` 为输入点集，`x` 为查询点。

```cpp
convex c,other;
c.construct(points);
other.construct(points2);
int pos=c.inside(x); // 0 内部，1 边界，2 外部
ld d=c.calipers(); // 直径
ld s=c.calipers(1); // 最小外接矩形面积
auto [l,r]=c.tangent(x);
if(l!=-1){
  line left{x,c.p[l],0},right{x,c.p[r],0};
}
convex sum=Minkowski::work(c,other);
```

== 圆

===& 公共结构

#code-info(
  [`circle{o,r}` 表示圆心为 `o`、半径为 `r` 的圆，要求 `r>=0`，零半径视为点。`area()`、`perimeter()` 求面积和周长。成员片段放入预留位置，`Circle` 命名空间放在结构体外。`eps` 是长度比较的绝对误差，可按题目尺度调整；本节的 `pi` 使用 `ld`。],
  [公共操作 $O(1)$。],
)
#code-file("code/geometry/circle.cpp")

=== 位置判定

#code-info(
  [`inside(x)` 返回 `0` 内部、`1` 边界、`2` 外部。`relation(c)` 返回 `0` 重合、`1` 内含、`2` 内切、`3` 相交、`4` 外切、`5` 相离；内含不区分哪个圆较大，零半径同时满足内外切时按内切处理。],
  [均为 $O(1)$。],
)
#code-file("code/geometry/circle/inside.cpp")
#code-file("code/geometry/circle/relation.cpp")

=== 求交

====& 线与圆

#code-info(
  [`intersect(l)` 返回圆周与直线、射线或线段的交点，按 `l.a` 到 `l.b` 的参数方向排列，共 `0/1/2` 个，相切只返回一个。端点重合时把 `l` 视为点。],
  [$O(1)$。依赖 `inside`，复用 `proj`。],
)
#code-file("code/geometry/circle/intersect-line.cpp")

====& 圆与圆

#code-info(
  [`intersect(c)` 返回两圆周的交点，共 `0/1/2` 个。正半径圆重合时有无穷多交点，返回空数组，用 `relation(c)==0` 区分；两个重合的零半径圆返回圆心。],
  [$O(1)$。依赖 `relation` 和线与圆求交。],
)
#code-file("code/geometry/circle/intersect-circle.cpp")

=== 切线

====& 点到圆的切点

#code-info(
  [`tangent(x)` 返回过 `x` 作圆切线的切点：圆外两个、圆上一个、圆内零个；零半径返回圆心。圆外点的切线可写成 `line{x,t,0}`；圆上点的切线方向垂直于半径。],
  [$O(1)$。依赖 `inside`，复用 `rot`。],
)
#code-file("code/geometry/circle/tangent-point.cpp")

====& 两圆公切线

#code-info(
  [`tangent(c)` 返回全部内外公切线，均为 `type=0` 的直线。同心圆返回空数组；正半径重合圆有无穷多条公切线，可由 `relation(c)==0` 区分。支持零半径，去除重复切线。],
  [$O(1)$，至多四条；本片段可独立选用。],
)
#code-file("code/geometry/circle/tangent-circle.cpp")

=== 构造圆

#code-info(
  [`Circle::diameter(a,b)` 返回以 `ab` 为直径的圆。`Circle::circum(a,b,c)`、`Circle::incircle(a,b,c)` 返回三点外接圆、三角形内切圆，类型为 `optional<circle>`；三点共线或重合时返回 `nullopt`。],
  [均为 $O(1)$，放在结构体外，仅依赖公共结构和向量运算。],
)
#code-file("code/geometry/circle/construct.cpp")

=== 最小圆覆盖

#code-info(
  [`Circle::cover(points)` 随机打乱副本，返回包含全部输入点的最小圆。支持重复点和共线点，空点集约定返回原点、零半径。使用基础模板的随机数生成器 `rnd`。],
  [期望 $O(n)$ 时间，最坏 $O(n^3)$；副本占用 $O(n)$ 空间。依赖 `inside` 和构造圆模块。],
)
#code-file("code/geometry/circle/min-circle.cpp")

=== 相交面积

====& 两圆相交面积

#code-info(
  [`area(c)` 返回两个圆盘公共部分的面积，支持相离、包含和重合。],
  [$O(1)$；本片段可独立选用。],
)
#code-file("code/geometry/circle/area-circle.cpp")

====& 圆与多边形相交面积

#code-info(
  [`area(p)` 返回圆盘与简单多边形的相交面积。顶点沿边界排列，首点存一次，顺逆时针均可；可传 `polygon.p` 或 `convex.p`。按线段与圆的交点拆分，每段累加三角形或扇形的有向面积。],
  [$O(n)$ 时间，$O(1)$ 额外空间。依赖 `inside` 和线与圆求交。],
)
#code-file("code/geometry/circle/area-polygon.cpp")

===& 使用示例

选择对应成员片段及其依赖，构造和覆盖模块放在结构体外。

```cpp
circle a{{0,0},2},b{{3,0},2};
vec x{4,0};
int pos=a.inside(x),rel=a.relation(b);
auto p=a.intersect(line{{-3,0},{3,0},2});
auto q=a.intersect(b),t=a.tangent(x);
auto lines=a.tangent(b);
auto c=Circle::circum({0,0},{4,0},{0,3});
if(c)cout<<c->r<<'\n';
auto d=Circle::incircle({0,0},{4,0},{0,3});
circle e=Circle::cover(points);
ld s=a.area(b),s2=a.area(poly.p);
```

参考：#link("https://github.com/kth-competitive-programming/kactl/tree/main/content/geometry")[KACTL 几何模块]。
