`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/20 14:59:50
// Design Name: 
// Module Name: dynamic_led3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dynamic_led3(
input [8:0]disp_data_right0,
input [8:0]disp_data_right1,
input [8:0]disp_data_right2,
input clk,
output  reg  [7:0] seg,
output  reg  [2:0] dig
	);
	
	//分频
	reg[24:0] clk_div_cnt=0;
	reg clk_div=0;
	always @ (posedge clk)
	begin
		if (clk_div_cnt==25000)
		begin
			clk_div=~clk_div;
			clk_div_cnt=0;
		end
		else 
		    clk_div_cnt=clk_div_cnt+1;
	end
	//3进制计数器
	reg [1:0] num=0;
	always @ (posedge clk_div)
	begin
		if (num>=2)
			num=0;
		else
			num=num+1;
	end
	
	//译码器
	always @ (num)
	begin	
		case(num)
		0:dig=3'b110;
		1:dig=3'b101;
		2:dig=3'b011;
		default: dig=0;
		endcase
	end
	
	//选择器，确定显示数据
	reg [8:0] disp_data;
	always @ (num)
	begin	
		case(num)
		0:disp_data=disp_data_right0;
		1:disp_data=disp_data_right1;
		2:disp_data=disp_data_right2;
		default: disp_data=0;
		endcase
	end
	//显示译码器
	always@(disp_data)
	begin
		case(disp_data)
		8'h0: seg=8'h3f;//顺序 DP,GFEDCBA,这里表示显示0
		8'h1: seg=8'h06;
		8'h2: seg=8'h5b;
		8'h3: seg=8'h4f;
		8'h4: seg=8'h66;
		8'h5: seg=8'h6d;
		8'h6: seg=8'h7d;
		8'h7: seg=8'h07;
		8'h8: seg=8'h7f;
		8'h9: seg=8'h6f;
		8'ha: seg=8'h77;
		8'hb: seg=8'h7c;
		8'hc: seg=8'h39;
		8'hd: seg=8'h5e;
		8'he: seg=8'h79;
		8'hf: seg=8'h71;
		8'h10:seg = 8'b10000000;//DP:H
		8'h11:seg = 8'b01000001;//up:AG
		8'h12:seg = 8'b01001000;//down:DG
		8'h13:seg = 8'b01000000;//IDLE:G
		
		8'h14:seg = 8'b00110111;//"N":N
		
		default: seg=0;
		endcase
	end
   
endmodule