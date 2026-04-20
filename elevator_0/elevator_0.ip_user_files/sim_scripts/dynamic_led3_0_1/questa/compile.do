vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 \
"../../../../elevator_0.srcs/sources_1/ip/dynamic_led3_0_1/dynamic_led3.v" \
"../../../../elevator_0.srcs/sources_1/ip/dynamic_led3_0_1/sim/dynamic_led3_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

