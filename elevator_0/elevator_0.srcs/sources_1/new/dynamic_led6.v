`timescale 1ns / 1ps

module dynamic_led6(
    input clk,
    input [8:0] disp_data_right0,
    input [8:0] disp_data_right1,
    input [8:0] disp_data_right2,
    input [8:0] disp_data_right3,
    input [8:0] disp_data_right4,
    input [8:0] disp_data_right5,
    output reg [7:0] seg,
    output reg [5:0] dig
);

    // 分频
    reg [24:0] clk_div_cnt = 0;
    reg clk_div = 0;
    always @(posedge clk) begin
        if (clk_div_cnt == 25000) begin
            clk_div = ~clk_div;
            clk_div_cnt = 0;
        end else begin
            clk_div_cnt = clk_div_cnt + 1;
        end
    end

    // 6进制计数器
    reg [2:0] num = 0;
    always @(posedge clk_div) begin
        if (num >= 5) begin
            num = 0;
        end else begin
            num = num + 1;
        end
    end

    // 译码器 (数码管位选，低电平有效)
    always @(num) begin
        case (num)
            0: dig = 6'b111110; // 第1位（最右）
            1: dig = 6'b111101; // 第2位
            2: dig = 6'b111011; // 第3位
            3: dig = 6'b110111; // 第4位（用于显示楼层）
            4: dig = 6'b101111; // 第5位
            5: dig = 6'b011111; // 第6位（最左）
            default: dig = 6'b111111;
        endcase
    end

    // 选择器，确定显示数据
    reg [8:0] disp_data;
    always @(num or 
        disp_data_right0 or disp_data_right1 or disp_data_right2 or 
        disp_data_right3 or disp_data_right4 or disp_data_right5) 
    begin    
        case (num)
            0: disp_data = disp_data_right0;
            1: disp_data = disp_data_right1;
            2: disp_data = disp_data_right2;
            3: disp_data = disp_data_right3;
            4: disp_data = disp_data_right4;
            5: disp_data = disp_data_right5;
            default: disp_data = 0;
        endcase
    end

    // 显示译码器 (添加小数点DP显示支持)
    reg [7:0] seg_base;
    always @(disp_data) begin
        case (disp_data[7:0])
            8'h0: seg_base = 8'h3f; // 0
            8'h1: seg_base = 8'h06; // 1
            8'h2: seg_base = 8'h5b; // 2
            8'h3: seg_base = 8'h4f; // 3
            8'h4: seg_base = 8'h66; // 4
            8'h5: seg_base = 8'h6d; // 5
            8'h6: seg_base = 8'h7d; // 6
            8'h7: seg_base = 8'h07; // 7
            8'h8: seg_base = 8'h7f; // 8
            8'h9: seg_base = 8'h6f; // 9
            8'ha: seg_base = 8'h77; // A
            8'hb: seg_base = 8'h7c; // B
            8'hc: seg_base = 8'h39; // C
            8'hd: seg_base = 8'h5e; // D
            8'he: seg_base = 8'h79; // E
            8'hf: seg_base = 8'h71; // F
            8'h10: seg_base = 8'b10000000; // 单独的 DP
            8'h11: seg_base = 8'b01000001; // SEG_UP (U)
            8'h12: seg_base = 8'b01001000; // SEG_DOWN (d)
            8'h13: seg_base = 8'b01000000; // SEG_IDLE (-)
            8'h14: seg_base = 8'b00110111; // SEG_alphabet_N (n)
            8'hFF: seg_base = 8'h00; // 熄灭
            default: seg_base = 8'h00;
        endcase
    end

    // 位段9检测及小数点常亮支持
    always @(seg_base or disp_data) begin
        if (disp_data[8])
            seg = seg_base | 8'h80;
        else
            seg = seg_base;
    end
endmodule
