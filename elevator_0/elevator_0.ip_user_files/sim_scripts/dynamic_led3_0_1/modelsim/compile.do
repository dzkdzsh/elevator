vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../elevator_0.srcs/sources_1/ip/dynamic_led3_0_1/dynamic_led3.v" \
"../../../../elevator_0.srcs/sources_1/ip/dynamic_led3_0_1/sim/dynamic_led3_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

