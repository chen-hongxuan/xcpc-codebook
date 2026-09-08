#import "../common.typ": *

= 基础 / Basic

== 比赛模板

#code-info(
  [`read()` 读整数; `chmin/chmax` 条件更新; `red` 单次归约; `qpow` 求模幂; `solve()` 为单组入口. ],
  [`read` 为 $Theta(k)$ ($k$ 为读取字符数), `qpow` 为 $O(log(t+1))$ , 其余辅助函数 $O(1)$ ; 额外空间均为 $O(1)$ . ],
)
#code-file("code/basic/template.cpp")

#note-box[
  *提交前检查: * 整数范围、数组边界、多测清空、递归深度, 以及输出格式.
]

== 对拍模板

#code-info(
  [`main()` 编译生成器、标准程序与待测程序, 循环生成数据并用 `diff` 比较输出, 直到发现差异. ],
  [时间正比于编译及已执行轮次的总耗时, 若始终无差异则不终止; 自身额外空间 $O(1)$ , 磁盘空间为一轮输入、输出与可执行文件总大小. ],
)
#code-file("code/basic/chk_template.cpp");
