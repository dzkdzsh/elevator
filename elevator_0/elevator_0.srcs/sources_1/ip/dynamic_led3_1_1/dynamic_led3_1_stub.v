// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Mon Apr 20 15:57:29 2026
// Host        : LAPTOP-21A831KV running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top dynamic_led3_1 -prefix
//               dynamic_led3_1_ dynamic_led3_2_stub.v
// Design      : dynamic_led3_2
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "dynamic_led3,Vivado 2017.4" *)
module dynamic_led3_1(disp_data_right0, disp_data_right1, 
  disp_data_right2, clk, seg, dig)
/* synthesis syn_black_box black_box_pad_pin="disp_data_right0[3:0],disp_data_right1[3:0],disp_data_right2[3:0],clk,seg[7:0],dig[2:0]" */;
  input [3:0]disp_data_right0;
  input [3:0]disp_data_right1;
  input [3:0]disp_data_right2;
  input clk;
  output [7:0]seg;
  output [2:0]dig;
endmodule
