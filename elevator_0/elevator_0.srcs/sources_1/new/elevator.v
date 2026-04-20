`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/19 20:17:38
// Design Name: 
// Module Name: elevator
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


module elevator(

    input  wire clk,          // 系统时钟 50MHz
    input  wire rst_n,        // 异步复位，低电平有效
    // 矩阵键盘引脚
    output reg  [3:0] row,    // 行扫描输出 (K3, M6, P10, R10) - 输出低电平选中某行
    input  wire [3:0] col,    // 列输入 (R12, T12, R11, T10) - 输入，低电平表示按键按下
    // 蜂鸣器
    output wire  buzzer,        // 蜂鸣器驱动引脚 (L2)
    input sw0,
    output reg [15:0] led,
    
    output [7:0] seg,
    output [2:0] dig
);



    localparam SEG_alphabet_O = 8'h0;  
    localparam SEG_alphabet_N = 8'h14; 
    localparam SEG_DP = 8'h10;
    localparam SEG_UP = 8'h11;  
    localparam SEG_DOWN = 8'h12; 
    localparam SEG_IDLE = 8'h13;
    reg [8:0]disp_data_right0;
    reg [8:0]disp_data_right1;
    reg [8:0]disp_data_right2;

        
    dynamic_led3_0 uu0(
    .clk(clk),
    .disp_data_right0(disp_data_right0),
    .disp_data_right1(disp_data_right1),
    .disp_data_right2(disp_data_right2),
    .seg(seg),
    .dig(dig)
    );   





    // 音阶频率对应计数周期 (系统时钟 50MHz)
    localparam DO_CYCNT = 47780;  // 523Hz
    localparam RE_CYCNT = 42580;  // 587Hz
    localparam MI_CYCNT =211;  // 659Hz
    localparam FA_CYCNT = 35820;  // 698Hz
    localparam SOL_CYCNT = 31890; // 784Hz
    localparam LA_CYCNT = 28410;  // 880Hz
    localparam SI_CYCNT = 25300;  // 988Hz
    localparam NO_KEY_CYCNT = 0;   // 无按键
    
        // 状态编码 (需要扩展位宽以支持更多状态)
    localparam POWER_OFF     = 4'b0000;
    localparam POWER_ON_INIT = 4'b0001;
    localparam IDLE          = 4'b0010;
    localparam DEBOUNCE      = 4'b0011;
    localparam DOOR_OPEN     = 4'b0100;
    localparam DOOR_WAIT     = 4'b0101;
    localparam DOOR_CLOSE    = 4'b0110;
    localparam MOVE_UP       = 4'b0111;
    localparam MOVE_DOWN     = 4'b1000;
    localparam ARRIVE        = 4'b1001;
    localparam PLAY        = 4'b1010;
    
        
    reg [4:0] state, next_state;
    reg [15:0] btn_reg;           // 16位按键寄存器，存储所有按键状态
    reg [23:0] cycle_cnt;         // 半周期计数值
    reg [15:0] debounce_cnt;      // 消抖计数器
    reg [23:0] buzzer_cnt;        // 蜂鸣器计数器
    reg buzzer_reg;               // 蜂鸣器内部寄存器
    reg [2:0]target_floor;
    reg [2:0] current_floor;
    // 行扫描相关寄存器
    reg [1:0] scan_cnt;  // 行扫描计数器：0,1,2,3
    reg [15:0] btn_temp;          // 临时按键寄存器
    
    // ============================================================
    // 矩阵键盘扫描模块 (1kHz扫描时钟)
    // 工作原理：
    // 1. 行输出依次输出低电平（0001 -> 0010 -> 0100 -> 1000 -> 循环）
    // 2. 当某行输出低电平时，读取列输入
    // 3. 如果某列为低电平，表示该行该列的按键被按下
    // 4. btn_reg中对应位为0表示按键按下，1表示未按下
    // ============================================================
    
    // 产生1kHz扫描时钟
    reg [15:0] scan_clk_cnt;
    reg scan_clk;
    reg [15:0] POWER_ON_INIT_1s;
    reg [15:0] DOOR_OPEN_1s ;
    reg [15:0]DOOR_WAIT_1s ;
    reg [15:0]DOOR_CLOSE_1s ;
    reg [15:0]MOVE_UP_3s ;
    reg [15:0]MOVE_DOWN_3s ;
    localparam SCAN_CLK_DIV = 25000;  // 50MHz / 50000/2=25000 = 1kHz
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_clk_cnt <= 16'd0;
            scan_clk <= 1'b0;
        end else begin
            if (scan_clk_cnt >= SCAN_CLK_DIV - 1) begin
                scan_clk_cnt <= 16'd0;
                scan_clk <= ~scan_clk;
            end else begin
                scan_clk_cnt <= scan_clk_cnt + 1'b1;
            end
        end
    end
    
    //上升沿，行扫描计数器
    always @(posedge scan_clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_cnt <= 2'd0;
        end else begin
            if (scan_cnt == 2'd3)
                scan_cnt <= 2'd0;
            else
                scan_cnt <= scan_cnt + 1'b1;
        end
    end
    // 行输出
    always @(*) begin
        case (scan_cnt)
            2'd0: row = 4'b1110;  // 第1行
            2'd1: row = 4'b1101;  // 第2行
            2'd2: row = 4'b1011;  // 第3行
            2'd3: row = 4'b0111;  // 第4行
            default: row = 4'b1110;
        endcase
    end
    
    // 锁存列值 (使用1kHz扫描时钟的上升沿)
    // col输入：低电平表示该列有按键按下
    always @(posedge scan_clk or negedge rst_n) begin
        if (!rst_n) begin
            btn_temp <= 16'hFFFF;  // 初始化为全1（无按键按下）
        end else begin
            case (scan_cnt)
                2'd0: btn_temp[3:0]   = col;   // 第1行，存到 btn[3:0]
                2'd1: btn_temp[7:4]   = col;   // 第2行，存到 btn[7:4]
                2'd2: btn_temp[11:8]  = col;   // 第3行，存到 btn[11:8]
                2'd3: btn_temp[15:12] = col;   // 第4行，存到 btn[15:12]
                default: btn_temp = btn_temp;
            endcase
        end
    end
    
//     按键寄存器更新 (在每个完整的扫描周期后更新)
    always @(posedge scan_clk or negedge rst_n) begin
        if (!rst_n) begin
            btn_reg <= 16'hFFFF;  // 初始化为全1（无按键按下）
        end else begin
            if (scan_cnt == 2'd3) begin
                // 扫描完第4行时，更新按键寄存器
                btn_reg <= btn_temp;
            end
        end
    end
    
    // ============================================================
    // 直接根据btn_reg计算cycle_cnt的组合逻辑
    // btn_reg中某位为0表示该按键被按下
    // ============================================================
    always @(*) begin
        // 默认无按键
        cycle_cnt = NO_KEY_CYCNT;
        
        // 检查第1行 (btn_reg[3:0])
        if (~btn_reg[0]) target_floor = 1;   // 第1行第1列 -> do
       
        else if (~btn_reg[12]) target_floor = 2;   // 第1行第3列 -> mi
        else if (~btn_reg[3]) target_floor = 1;    // 第1行第4列 -> fa
        
        // 检查第2行 (btn_reg[7:4])
  
        else if (~btn_reg[15]) target_floor = 2;    // 第2行第2列 -> la
       
        // 第2行第4列及其他按键忽略（无声音）
    end
    
    // 检查是否有按键按下 (只要有一位为0表示有按键按下)
    wire key_pressed = (btn_reg != 16'hFFFF);
    
    // ============================================================
    // 三段式状态机
    // ============================================================
    
    // 第一段：状态寄存器 (使用1kHz扫描时钟)
    always @(posedge scan_clk or negedge rst_n) begin
        if (!rst_n)
            state <= POWER_OFF;
        else if (!sw0)
            state <= POWER_OFF;
        else 
            state <= next_state;
    end
    
     // 第二段：下一状态判断 (组合逻辑)
    always @(*) begin
        next_state = state; // 默认保持当前状态
        case (state)

            POWER_OFF: begin
                if (sw0)
                    next_state = POWER_ON_INIT;
                else
                    next_state = POWER_OFF;
            end

            POWER_ON_INIT: begin
                if ( POWER_ON_INIT_1s >=1000)
                    next_state = IDLE;
                else
                    next_state = POWER_ON_INIT;
            end

            IDLE: begin
                if (key_pressed)
                    next_state = DEBOUNCE;
                else
                    next_state = IDLE;
            end

            DEBOUNCE: begin
                if (debounce_cnt >= 20-1)
                    if(target_floor > current_floor)
                    next_state = MOVE_UP;
                    else if (target_floor < current_floor)
                    next_state = MOVE_DOWN;
                    else
                    next_state = DOOR_OPEN;
                else
                    next_state = DEBOUNCE;
            end

            DOOR_OPEN: begin
                if (DOOR_OPEN_1s >= 1000)
                    next_state = DOOR_WAIT;
                else
                    next_state = DOOR_OPEN;
            end

            DOOR_WAIT: begin
                if (DOOR_WAIT_1s >= 1000)
                    next_state = DOOR_CLOSE;
                else
                    next_state = DOOR_WAIT;
            end

            DOOR_CLOSE: begin
                if (DOOR_CLOSE_1s >= 1000)
                    if(target_floor > current_floor)
                next_state = MOVE_UP;
                else if (target_floor < current_floor)
                next_state = MOVE_DOWN;
                else
                next_state = IDLE;
                
                else
                    next_state = DOOR_CLOSE;
            end

            MOVE_UP: begin
                if (MOVE_UP_3s >= 3000)
                    next_state = ARRIVE;
                else
                    next_state = MOVE_UP;
                    current_floor = 2;
                    
            end

            MOVE_DOWN: begin
                if (MOVE_DOWN_3s >= 3000)
                    next_state = ARRIVE;
                else
                    next_state = MOVE_DOWN;
                    current_floor = 1;
            end

            ARRIVE: begin

                    next_state = DOOR_OPEN;


            end

            default: next_state = POWER_OFF;
        endcase
    end

    
    // 第三段：状态输出逻辑 (使用1kHz扫描时钟)
    always @(posedge scan_clk or negedge rst_n) begin
        if (!rst_n) begin
            debounce_cnt <= 16'd0;
            POWER_ON_INIT_1s <= 16'd0;

            MOVE_UP_3s <= 16'd0;
            
            target_floor <= 2'd1;
           
        
                        
        end 
        else begin
            case (state)
        
                POWER_OFF: begin
                    debounce_cnt <= 16'd0;
                    POWER_ON_INIT_1s <= 16'd0;
                    DOOR_OPEN_1s <= 16'd0;
                    DOOR_WAIT_1s <= 16'd0;
                    DOOR_CLOSE_1s <= 16'd0;
                    MOVE_UP_3s <= 16'd0;
                    MOVE_DOWN_3s <= 16'd0;
                    
                    disp_data_right2 <= SEG_alphabet_O;
                    disp_data_right1 <= 8'hf;
                    disp_data_right0 <= 8'hf;
                    
                    led[15] <= 1'b1; // 点亮关机灯
                    led[14] <= 1'b0; // 必须显式熄灭开机灯！
                end
        
                POWER_ON_INIT: begin
                    POWER_ON_INIT_1s <= POWER_ON_INIT_1s + 1'b1;
                    
                    disp_data_right2 <= SEG_alphabet_O;
                    disp_data_right1 <= SEG_alphabet_N;
                    disp_data_right0 <= 8'hff;
                    
                    led[15] <= 1'b0; // 离开关机态，必须显式熄灭关机灯！
                    led[14] <= 1'b1; // 点亮开机初始化灯
                end
        
                    IDLE: begin
                    
                    led = 16'b0;
                    
                    disp_data_right2 <= SEG_IDLE;
                    disp_data_right1 <= 8'hff;
                    disp_data_right0 <= 8'hff;
                    end
        
                    DEBOUNCE: begin
                         debounce_cnt <= debounce_cnt + 1'b1;
                    end
        
                    DOOR_OPEN: begin
                        DOOR_OPEN_1s<= DOOR_OPEN_1s + 1'b1;
                    end
        
                    DOOR_WAIT: begin
                     DOOR_WAIT_1s<= DOOR_WAIT_1s + 1'b1;
                    end
        
                    DOOR_CLOSE: begin
                        DOOR_CLOSE_1s<= DOOR_CLOSE_1s + 1'b1;
                    end
        
                    MOVE_UP: begin
                       MOVE_UP_3s<= MOVE_UP_3s + 1'b1;
                 if((~btn_reg[15])&&(debounce_cnt >= 20-1))
                 led[3] <= 1'b1 ;
                 else if ((~btn_reg[12])&&(debounce_cnt >= 20-1))
                 led[1] <= 1'b1 ;
                 
                 disp_data_right2 <= SEG_UP;
                 disp_data_right1 <= 8'hff;
                 disp_data_right0 <= 8'hff;
               
                       
                    end
        
                    MOVE_DOWN: begin
                       MOVE_DOWN_3s<= MOVE_DOWN_3s + 1'b1;
                   if(~btn_reg[3]&&(debounce_cnt >= 20-1))
                       led[2]  <= 1'b1 ;
                        else if (~btn_reg[0]&&(debounce_cnt >= 20-1))
                       led[0]  <= 1'b1 ;
                 disp_data_right2 <= SEG_DOWN;
                       disp_data_right1 <= 8'hff;
                       disp_data_right0 <= 8'hff;                    
                       
                    end
        
                    ARRIVE: begin
                        led = 16'b0;
                            
        
        
                    end

                default: ;
            endcase
        end
    end
    
    // ============================================================
    // 蜂鸣器频率生成模块 (使用50MHz系统时钟)
    // ============================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buzzer_cnt <= 24'd0;
            buzzer_reg <= 1'b0;
        end else begin
            if (state == PLAY && cycle_cnt != NO_KEY_CYCNT) begin
                if (buzzer_cnt >= cycle_cnt - 1) begin
                    buzzer_cnt <= 24'd0;
                    buzzer_reg <= ~buzzer_reg;
                end else begin
                    buzzer_cnt <= buzzer_cnt + 1'b1;
                end
            end else begin
                buzzer_cnt <= 24'd0;
                buzzer_reg <= 1'b0;
            end
        end
    end
    
    // 蜂鸣器输出
    assign buzzer = buzzer_reg;


endmodule
