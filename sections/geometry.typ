#import "../common.typ": code-file, code-info as base-code-info

#let code-info(api, complexity) = {
  set par(leading: 0.35em)
  base-code-info(api, complexity)
}

= 计算几何

本章沿用基础模板中的 `ld`、`finf` 和 `chmax`。

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

各代码段按顺序组成 `convex`。查询使用 `construct` 得到的顶点序列。

=== 构造

#code-info(
  [`construct(points)` 用 Andrew 单调链重建凸包。`p` 逆时针排列，首点存一次，共线边只保留两端。],
  [$O(n log n)$ 时间，$O(n)$ 空间。],
)
#code-file("code/geometry/convex.cpp", part: "construct")

=== 询问点是否在凸包内

#code-info(
  [`inside(x)` 用扇形二分返回 `0` 内部、`1` 边界、`2` 外部。],
  [$O(log h)$ 时间，$O(1)$ 额外空间，$h$ 为凸包顶点数。],
)
#code-file("code/geometry/convex.cpp", part: "inside")

=== 旋转卡壳求直径

#code-info(
  [`diameter()` 返回凸包上最远两点的欧氏距离。顶点少于两个时返回 `0`。],
  [$O(h)$ 时间，$O(1)$ 额外空间。],
)
#code-file("code/geometry/convex.cpp", part: "diameter")
