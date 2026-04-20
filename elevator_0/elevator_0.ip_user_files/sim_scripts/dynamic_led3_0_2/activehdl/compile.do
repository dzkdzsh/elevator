vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../../elevator_0.srcs/sources_1/ip/dynamic_led3_0_2/dynamic_led3/dynamic_led3.srcs/sources_1/new/dynamic_led3.v" \
"../../../../elevator_0.srcs/sources_1/ip/dynamic_led3_0_2/sim/dynamic_led3_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

