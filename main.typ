#import "template.typ": codebook, code-file, note-box

#show: codebook.with(
  title: "我的 XCPC 代码模板库",
  short-title: "XCPC Codebook",
  school: "你的学校 / Your University",
  team: "你的队名 / Your Team",
  members: ("队员 A", "队员 B", "队员 C"),
)

= 基础 / Basic

== 比赛模板

#code-file("code/basic/template.cpp")

#note-box[
  *提交前检查：* 整数范围、数组边界、多测清空、递归深度，以及输出格式。
]

= 数据结构 / Data Structure

== 并查集 / Disjoint Set Union

#code-file("code/data-structure/dsu.cpp", highlights: (13, 18))

= 图论 / Graph

== Dijkstra

Complexity: $O((V + E) log V)$ with a binary heap.

#code-file("code/graph/dijkstra.cpp")

= 数学 / Math

== Extended Euclidean algorithm

For $a x + b y = gcd(a, b)$, the function below returns $(g, x, y)$.

#code-file("code/math/exgcd.cpp")

= 检查表 / Checklist

#include "notes/checklist.typ"
