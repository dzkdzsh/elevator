vlib work
vlib riviera

vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../../elevator_0.srcs/sources_1/ip/dynamic_led3_0_1/dynamic_led3.v" \
"../../../../elevator_0.srcs/sources_1/ip/dynamic_led3_0_1/sim/dynamic_led3_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

