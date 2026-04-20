vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../elevator_0.srcs/sources_1/ip/dynamic_led3_0_2/dynamic_led3/dynamic_led3.srcs/sources_1/new/dynamic_led3.v" \
"../../../../elevator_0.srcs/sources_1/ip/dynamic_led3_0_2/sim/dynamic_led3_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

