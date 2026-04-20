vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../../elevator_0.srcs/sources_1/ip/dynamic_led3_1_1/dynamic_led3.v" \
"../../../../elevator_0.srcs/sources_1/ip/dynamic_led3_1_1/sim/dynamic_led3_1.v" \


vlog -work xil_defaultlib \
"glbl.v"

