## debug and dump waveform

vlog -vlog01compat -f flist.f
## vlog: compile verilog code   -64: run in 64 bits mode
## -o0: no optimization -vlog01compat: compatible with 2001 version Verilog grammer

vsim -c +nowarnTSCALE -L ./work  -voptargs=+acc -l load.log tb
## vsim: Modelsim的启动命令 
## -c: command line mode 
## -L: load speciflc lib
## +nowarnTSCALE: 编译时不发出与时间刻度相关的警告
## unisim是Xilinx提供的仿真库
## -novopt： ban optimization of the code
## -l:指定并创建一个日志文件，并将输出保存到这个日志文件中

radix hex
## 波形以hexal进行显示

add log -r /tb/*
## 将仿真中产生的所有信号的波形add wave
## add log可以添加日志 -r: recursiv递归添加所有信号 

##do ./wave.do
run -all