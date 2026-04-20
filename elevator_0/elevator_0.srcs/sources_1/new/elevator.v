`timescale 1ns / 1ps

module elevator(
    input  wire clk,          // 系统时钟 50MHz
    input  wire rst_n,        // 异步复位，低电平有效
    output reg  [3:0] row,    // 行扫描输出
    input  wire [3:0] col,    // 列输入
    output wire buzzer,       
    input sw0,                // 启动开关 (0:关机, 1:开机)
    input sw11,               // 复位开关 (0:立即回1楼, 1:正常)
    output reg [15:0] led,
    output [7:0] seg,
    output [2:0] dig
);

    // 数码管显示字符定义
    localparam SEG_alphabet_O = 8'h0;  // 数字0
    localparam SEG_alphabet_N = 8'h14; // 小写n
    localparam SEG_DP   = 8'h10;       // 小数点
    localparam SEG_UP   = 8'h11;       // 上行 U
    localparam SEG_DOWN = 8'h12;       // 下行 d
    localparam SEG_IDLE = 8'h13;       // 待机 -
    localparam SEG_OFF  = 8'hff;       // 全灭

    reg [8:0] disp_data_right0;
    reg [8:0] disp_data_right1;
    reg [8:0] disp_data_right2;

    dynamic_led3_1 uu0(
        .clk(clk),
        .disp_data_right0(disp_data_right0),
        .disp_data_right1(disp_data_right1),
        .disp_data_right2(disp_data_right2),
        .seg(seg),
        .dig(dig)
    );   

    // FSM 状态定义
    localparam S_POWER_OFF      = 4'd0;
    localparam S_POWER_ON_INIT  = 4'd1;
    localparam S_RESET_TO_1F    = 4'd2;
    localparam S_IDLE_1F        = 4'd3;
    localparam S_IDLE_2F        = 4'd4;
    localparam S_MOVE_UP        = 4'd5;
    localparam S_MOVE_DOWN      = 4'd6;
    
    reg [3:0] state, next_state;
    reg [3:0] mem_state; // 记忆楼层状态

    // 矩阵扫描相关寄存器
    reg [1:0] scan_cnt;
    reg [15:0] btn_temp;
    reg [15:0] btn_reg;
    reg [15:0] btn_reg_last;
    wire [15:0] btn_fall = ~btn_reg & btn_reg_last; // 边缘检测，按下的瞬间产生一个脉冲

    // 时钟分频生成 1kHz 扫描时钟
    reg [15:0] scan_clk_cnt;
    reg scan_clk;
    localparam SCAN_CLK_DIV = 25000;
    
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
    
    // 行扫描
    always @(posedge scan_clk or negedge rst_n) begin
        if (!rst_n) scan_cnt <= 2'd0;
        else scan_cnt <= (scan_cnt == 2'd3) ? 2'd0 : scan_cnt + 1'b1;
    end

    always @(*) begin
        case (scan_cnt)
            2'd0: row = 4'b1110;
            2'd1: row = 4'b1101;
            2'd2: row = 4'b1011;
            2'd3: row = 4'b0111;
            default: row = 4'b1110;
        endcase
    end
    
    // 锁存列输入
    always @(posedge scan_clk or negedge rst_n) begin
        if (!rst_n) begin
            btn_temp <= 16'hFFFF;
            btn_reg <= 16'hFFFF;
            btn_reg_last <= 16'hFFFF;
        end else begin
            case (scan_cnt)
                2'd0: btn_temp[3:0]   <= col;
                2'd1: btn_temp[7:4]   <= col;
                2'd2: btn_temp[11:8]  <= col;
                2'd3: btn_temp[15:12] <= col;
            endcase
            // 完成一轮扫描后更新
            if (scan_cnt == 2'd3) begin
                btn_reg_last <= btn_reg;
                btn_reg <= btn_temp; 
            end
        end
    end
    
    // ============================================================
    // 核心 FSM 设计 (使用 1kHz = 1ms 的时钟驱动)
    // ============================================================
    
    reg [15:0] run_timer_ms; // 毫秒级计时器 (0-2999) 对应 0.0s - 2.9s
    reg req_up;              // 上行请求记忆
    reg req_down;            // 下行请求记忆

    // 1. 状态跳转同步逻辑
    always @(posedge scan_clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_POWER_OFF;
        end else if (!sw11 && state != S_RESET_TO_1F) begin
            // 最高优先级：sw11硬复位，直接回1F
            state <= S_RESET_TO_1F;
        end else if (!sw0 && state != S_POWER_OFF && state != S_RESET_TO_1F) begin
            // 次高优先级：sw0关机
            state <= S_POWER_OFF;
        end else begin
            state <= next_state;
        end
    end

    // 2. 次态计算逻辑 (组合逻辑)
    always @(*) begin
        next_state = state; 
        case (state)
            S_POWER_OFF: begin
                if (sw0) next_state = S_POWER_ON_INIT;
            end
            S_POWER_ON_INIT: begin
                if (run_timer_ms >= 1000) 
                    next_state = mem_state; // 恢复楼层记忆
            end
            S_RESET_TO_1F: begin
                // sw11 恢复高电平，且到达1楼(假设要跑够时间或者立刻到，这里给3秒运行)
                if (sw11 && run_timer_ms >= 2999) 
                    next_state = S_IDLE_1F;
            end
            S_IDLE_1F: begin
                if (req_up) next_state = S_MOVE_UP;
            end
            S_IDLE_2F: begin
                if (req_down) next_state = S_MOVE_DOWN;
            end
            S_MOVE_UP: begin
                if (run_timer_ms >= 2999) begin
                    if (req_down) next_state = S_MOVE_DOWN;
                    else next_state = S_IDLE_2F;
                end
            end
            S_MOVE_DOWN: begin
                if (run_timer_ms >= 2999) begin
                    if (req_up) next_state = S_MOVE_UP;
                    else next_state = S_IDLE_1F;
                end
            end
            default: next_state = S_POWER_OFF;
        endcase
    end

    // 3.状态输出逻辑 & 并发记忆机制 (时序逻辑)
    always @(posedge scan_clk or negedge rst_n) begin
        if (!rst_n) begin
            run_timer_ms <= 0;
            req_up <= 0; req_down <= 0;
            led <= 16'b0;
            mem_state <= S_IDLE_1F;
            disp_data_right0 <= SEG_OFF;
            disp_data_right1 <= SEG_OFF;
            disp_data_right2 <= SEG_OFF;
        end 
        else begin

            // == 计时器累加策略 ==
            if (state == S_POWER_ON_INIT || state == S_MOVE_UP || state == S_MOVE_DOWN || state == S_RESET_TO_1F) begin
                if (run_timer_ms < 3000) run_timer_ms <= run_timer_ms + 1;
            end else begin
                run_timer_ms <= 0; 
            end

            // == 按键盲区独立侦听与记忆机制 (关键得分点) ==
            if(sw0 && sw11 && state != S_POWER_OFF && state != S_POWER_ON_INIT) begin
                // 上楼请求 (如果不在IDLE_2F，按下键立刻锁死点亮，并记录方向)
                if ((btn_fall[15] || btn_fall[12]) && state != S_IDLE_2F) begin
                    req_up <= 1;
                    if (btn_fall[15]) led[3] <= 1'b1; // 内呼 2F
                    if (btn_fall[12]) led[1] <= 1'b1; // 外呼 2F 向下
                end
                // 下楼请求 (如果不在IDLE_1F，按下键立刻锁死点亮)
                if ((btn_fall[3] || btn_fall[0]) && state != S_IDLE_1F) begin
                    req_down <= 1;
                    if (btn_fall[3]) led[2] <= 1'b1; // 内呼 1F
                    if (btn_fall[0]) led[0] <= 1'b1; // 外呼 1F 向上
                end
            end

            // == 状态动作行为 ==
            case (state)
                S_POWER_OFF: begin
                    disp_data_right2 <= SEG_alphabet_O; // "O"
                    disp_data_right1 <= 8'hf;           // "F"
                    disp_data_right0 <= 8'hf;           // "F"
                    led[15] <= 1'b1; led[14] <= 1'b0;
                end

                S_POWER_ON_INIT: begin
                    disp_data_right2 <= SEG_alphabet_O; // "O"
                    disp_data_right1 <= SEG_alphabet_N; // "N"
                    disp_data_right0 <= SEG_OFF;
                    led[15] <= 1'b0; led[14] <= 1'b1;
                end

                S_RESET_TO_1F: begin
                    req_up <= 0; req_down <= 0; led[3:0] <= 0;
                    disp_data_right2 <= SEG_DOWN; // 强制下行
                    disp_data_right1 <= (run_timer_ms/1000) % 10; // 秒
                    disp_data_right0 <= (run_timer_ms/100) % 10;  // 0.1秒精度
                    mem_state <= S_IDLE_1F;
                end

                S_IDLE_1F: begin
                    disp_data_right2 <= SEG_IDLE;
                    disp_data_right1 <= 8'h0;
                    disp_data_right0 <= 8'h0; 
                    req_down <= 0; led[2] <= 0; led[0] <= 0; // 清除下行记忆和对应的灯
                    mem_state <= S_IDLE_1F;
                end

                S_IDLE_2F: begin
                    disp_data_right2 <= SEG_IDLE;
                    disp_data_right1 <= 8'h0;
                    disp_data_right0 <= 8'h0; 
                    req_up <= 0; led[3] <= 0; led[1] <= 0;   // 清除上行记忆和对应的灯
                    mem_state <= S_IDLE_2F;
                end

                S_MOVE_UP: begin
                    disp_data_right2 <= SEG_UP;
                    disp_data_right1 <= (run_timer_ms/1000) % 10; 
                    disp_data_right0 <= (run_timer_ms/100) % 10;  
                end

                S_MOVE_DOWN: begin
                    disp_data_right2 <= SEG_DOWN;
                    disp_data_right1 <= (run_timer_ms/1000) % 10; 
                    disp_data_right0 <= (run_timer_ms/100) % 10;  
                end
            endcase
            
            // 硬件复位(sw11)清除所有灯和请求
            if (!sw11) begin
                req_up <= 0; req_down <= 0; led[3:0] <= 0; led[15:14] <= 0;
            end
        end
    end

    assign buzzer = 1'b0; // 蜂鸣器功能在此先占位清零

endmodule
