#import "../common.typ": *

= 基础 / Basic

== 基础模板

#code-info(
  [`read()` 读整数; `write(x,ch=0)` 输出整数并可附加字符 `ch`, 可用于 `#define int __int128` 时的整数输出; `chmin/chmax` 条件更新; `red` 单次归约; `qpow` 求模幂; `solve()` 为单组入口. ],
  [`read` 为 $Theta(k)$ ($k$ 为读取字符数); `write` 时间与额外空间为 $Theta(d)$ ($d$ 为输出位数); `qpow` 为 $O(log(t+1))$ , 其余辅助函数时间 $O(1)$ ; 除 `write` 外额外空间均为 $O(1)$ . ],
)
#code-file("code/basic/template.cpp")

#note-box[
  *提交前检查: * 整数范围、数组边界、多测清空、递归深度, 以及输出格式.
]

== 对拍脚本

#code-info(
  [依次编译标准程序、待测程序和数据生成器, 循环对拍至输出不同; 编译或运行失败时停止. `diff` 忽略空白数量与空行差异. ],
  [时间正比于编译及已执行轮次的总耗时, 若始终无差异则不终止; 自身额外空间 $O(1)$ , 磁盘空间为一轮输入、输出与可执行文件总大小. ],
)

#code-file("code/basic/check.sh", lang: "bash")

*使用格式:*

```bash
check ac.cpp wa.cpp gen.cpp [FILE]
```

前三参依次为标准程序、待测程序和数据生成器的源文件, *文件名都必须带 `.cpp` 后缀, 不能省略*. 第四参为当前目录下的工作目录名, 可省略, 默认为 `FILE`; 目录内生成 `ac`、`wa`、`gen`, 并保留最后一轮的 `data.in`、`ac.out` 和 `wa.out`. 可用 `Ctrl+C` 手动停止.

*比赛机器首次配置:* 将上述脚本写入 `~/check.sh`, 执行 `chmod +x ~/check.sh` 赋予执行权限, 然后在 `~/.bashrc` 末尾加入:

```bash
alias check='~/check.sh'
```

保存后执行 `source ~/.bashrc` 重新加载 Bash 配置, 当前终端即可使用 `check`.

== ASan 调试脚本

启用 AddressSanitizer、UndefinedBehaviorSanitizer、常用编译警告和调试信息, 在当前目录生成 `a.out`.

#code-file("code/basic/asan.sh", lang: "bash")

*使用格式:*

```bash
asan code.cpp
./a.out
```

源文件名 *必须带 `.cpp` 后缀, 不能省略*. `asan` 只负责编译; 编译成功后执行 `./a.out`, 在运行时检查内存错误和未定义行为.

*比赛机器首次配置:* 将上述脚本写入 `~/asan.sh`, 执行 `chmod +x ~/asan.sh` 赋予执行权限, 然后在 `~/.bashrc` 末尾加入:

```bash
alias asan='~/asan.sh'
```

保存后执行 `source ~/.bashrc` 重新加载 Bash 配置, 当前终端即可使用 `asan`.
