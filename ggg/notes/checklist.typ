== 赛前五分钟检查

- 临时关闭终端内存限制: ulimit -s unlimited
- 永久关闭终端内存限制:
  1. 打开 `~/.bashrc`
  2. 在配置文件末尾添加 `ulimit -s unlimited`
  3. 保存退出后在终端运行 `source ~/.bashrc`
- 十年oi一场空, 不开longlong见祖宗
- 多测不清空, 亲人两行泪

== 常用常数

#table(
  columns: (1fr, 1fr),
  stroke: 0.35pt + luma(150),
  inset: 2pt,
  [常数], [数值],
  [$pi$], [$3.141592653589793$],
  [$sqrt(2)$], [$1.414213562373095$],
  [$ln 2$], [$0.693147180559945$],
)
