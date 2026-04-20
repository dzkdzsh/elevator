`timescale 1ns / 1ps

module elevator(
    input  wire clk,          // 系统时钟 50MHz
    input  wire rst_n,        // 异步复位，低电平有效
    output reg  [3:0] row,    // 行扫描输出
    input  wire [3:0] col,    // 列输入
    output wire buzzer,       
    input sw0,                // 启动开关(0:关机, 1:开机) output reg [15 :0] led = 16'b0,
    output [7:0] seg,
    output [5:0] dig,
    output reg [15:0]led
);

    // 数码管显示字符定义
    localparam SEG_alphabet_O = 8'h0;  // 数字0
    localparam SEG_alphabet_N = 8'h14; // 小写n
    localparam SEG_DP   = 8'h10;       // 小数点
    localparam SEG_UP   = 8'h11;       // 上行 U
    localparam SEG_DOWN = 8'h12;       // 下行 d
    localparam SEG_IDLE = 8'h13;       // 待机 -
    localparam SEG_OFF  = 8'hff;       // 全灭

    reg [8:0] disp_data_right0 = SEG_OFF;
    reg [8:0] disp_data_right1 = SEG_OFF;
    reg [8:0] disp_data_right2 = SEG_OFF;

    reg [8:0] disp_data_right3 = 9'h0ff; 
    reg [8:0] disp_data_right4 = 9'h0ff;
    reg [8:0] disp_data_right5 = 9'h0ff;

    dynamic_led6 uu0(
        .clk(clk),
        .disp_data_right0(disp_data_right0), 
        .disp_data_right1(disp_data_right1),
        .disp_data_right2(disp_data_right2),
        .disp_data_right3(disp_data_right3),
        .disp_data_right4(disp_data_right4),
        .disp_data_right5(disp_data_right5),
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
    localparam S_DOOR_1F        = 4'd7;
    localparam S_DOOR_2F        = 4'd8;
    
    reg [3:0] state = S_POWER_OFF;
    reg [3:0] next_state;
    reg [3:0] mem_state = S_IDLE_1F; // 记忆楼层，上电默认1F

    // 矩阵扫描相关寄存器
    reg [1:0] scan_cnt = 0;
    reg [15:0] btn_temp = 16'hFFFF;
    reg [15:0] btn_reg = 16'hFFFF;
    reg [15:0] btn_reg_last = 16'hFFFF;
    reg [15:0] btn_fall = 16'hFFFF;

    // 时钟分频生成 1kHz 扫描时钟
    reg [15:0] scan_clk_cnt = 0;
    reg scan_clk = 0;
    localparam SCAN_CLK_DIV = 25000;
    
    always @(posedge clk) begin
    
    btn_fall = ~btn_reg & btn_reg_last; // 边缘检测，按下的瞬间产生一个脉冲
        if (1) begin
            if (scan_clk_cnt >= SCAN_CLK_DIV - 1) begin
                scan_clk_cnt <= 16'd0;
                scan_clk <= ~scan_clk;
            end else begin
                scan_clk_cnt <= scan_clk_cnt + 1'b1;
            end
        end
    end
    
    // 行扫
    always @(posedge scan_clk) begin
        scan_cnt <= (scan_cnt == 2'd3) ? 2'd0 : scan_cnt + 1'b1;
    end

    always @(*) begin
        case (scan_cnt)
            2'd0 : row = 4'b1110;
            2'd1: row = 4'b1101;
            2'd2: row = 4'b1011;
            2'd3: row = 4'b0111;
            default: row = 4'b1110;
        endcase
    end
    
    // 锁存列输入
    always @(posedge scan_clk) begin
        if (1) begin
            case (scan_cnt)
                2'd0 : btn_temp[3:0]   <= col;
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
    
    // 核心 FSM 设计 (使用 1kHz = 1ms 的时钟驱动) 
    reg [23:0] buzz_freq_cnt = 0;
    reg buzz_out = 0;
    assign buzzer = buzz_out; // 蜂鸣器驱动信号连接顶层输出

    // 电梯到达新楼层时，蜂鸣器发出间隔0.5s的三声清晰“嘀”声
    // 到站蜂鸣器分段提示音
    wire buzz_en = (state == S_DOOR_1F || state == S_DOOR_2F) && 
                   ((run_timer_ms < 500) || 
                    (run_timer_ms >= 1000 && run_timer_ms < 1500) || 
                    (run_timer_ms >= 2000 && run_timer_ms < 2500));

    always @(posedge clk) begin
        if (!buzz_en || !sw0) begin
            buzz_out <= 0;
            buzz_freq_cnt <= 0;
        end else begin
            // 发出1000Hz的提示音
            if (buzz_freq_cnt >= 25000) begin
                buzz_out <= ~buzz_out;
                buzz_freq_cnt <= 0;
            end else begin
                buzz_freq_cnt <= buzz_freq_cnt + 1;
            end
        end
    end

    reg [15:0] run_timer_ms = 0; // 毫秒级计时器 (0-2999) 对应 0.0s - 2.9s
    reg req_up = 0;              // 上行请求记忆
    reg req_down = 0;            // 下行请求记忆

    // 1. 状态跳转同步逻辑
    always @(posedge scan_clk) begin
        if (!sw0 && state != S_POWER_OFF) begin
            // 关机开关拥有最高优先级
            state <= S_POWER_OFF;
        end else if (!rst_n && state != S_POWER_OFF && state != S_POWER_ON_INIT && state != S_IDLE_1F && state != S_RESET_TO_1F) begin
            // 只有当不在底部楼层且非关机时，复位后触发沉降动作
            // 否则保持原位，按键被独立侦听逻辑统一清除
            state <= S_RESET_TO_1F;
        end else begin
            state <= next_state;
        end
    end

    // 2. 次态计算逻辑 (组合逻辑)
    always @(*) begin
        next_state = state; 
        case (state) S_POWER_OFF: begin
                if (sw0) next_state = S_POWER_ON_INIT;
            end
            S_POWER_ON_INIT: begin
                if (run_timer_ms >= 1000) 
                    next_state = mem_state; // 恢复楼层记忆
            end
            S_RESET_TO_1F: begin
                // 给硬件复位动画3秒运行时间
                if (rst_n && run_timer_ms >= 2999) 
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
                    next_state = S_DOOR_2F; // 靠站后开门
                end
            end
            S_DOOR_2F: begin
                if (run_timer_ms >= 2999) begin
                    if (req_down) next_state = S_MOVE_DOWN;
                    else next_state = S_IDLE_2F;
                end
            end
            S_MOVE_DOWN: begin
                if (run_timer_ms >= 2999) begin
                    next_state = S_DOOR_1F; // 靠站后开门
                end
            end
            S_DOOR_1F: begin
                if (run_timer_ms >= 2999) begin
                    if (req_up) next_state = S_MOVE_UP;
                    else next_state = S_IDLE_1F;
                end
            end
            default: next_state = S_POWER_OFF;
        endcase
    end

    // 3.状态输出逻辑 & 并发记忆机制 (时序逻辑)
    always @(posedge scan_clk) begin
        if (1) begin

            // 计时器累加与清零机制
            if (state != next_state) begin
                run_timer_ms <= 0; // 状态转移后计时器归零
            end else if (state == S_POWER_ON_INIT || state == S_MOVE_UP || state == S_MOVE_DOWN || state == S_RESET_TO_1F || state == S_DOOR_1F || state == S_DOOR_2F) begin
                if (run_timer_ms < 3000) run_timer_ms <= run_timer_ms + 1;
            end else begin
                run_timer_ms <= 0;
            end

            // 按键盲区跨状态边界独立侦听和记忆机制
            if(sw0 && rst_n && state != S_POWER_OFF && state != S_POWER_ON_INIT) begin
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

            // 动作执行
            case (state) S_POWER_OFF: begin
                    disp_data_right2 <= SEG_alphabet_O;
                    disp_data_right5 <= SEG_OFF; disp_data_right4 <= SEG_OFF; disp_data_right3 <= SEG_OFF; // "O"
                    disp_data_right1 <= 8'hf;           // "F"
                    disp_data_right0 <= 8'hf;           // "F"
                    led[15] <= 1'b1; led[14] <= 1'b0;
                    led[11:0] <= 12'b0;
                end

                S_POWER_ON_INIT: begin
                    disp_data_right2 <= SEG_alphabet_O;
                    disp_data_right5 <= SEG_OFF; disp_data_right4 <= SEG_OFF; disp_data_right3 <= SEG_OFF; // "O"
                    disp_data_right1 <= SEG_alphabet_N; // "N"
                    disp_data_right0 <= SEG_OFF;
                    led[15] <= 1'b0; led[14] <= 1'b1;
                end

                S_RESET_TO_1F: begin
                    req_up <= 0; req_down <= 0; led[3:0] <= 0;
                    // 强制复位也呈现下行动画
                    disp_data_right3 <= (run_timer_ms < 2000) ? 8'h2  : 8'h1; disp_data_right2 <= SEG_DOWN; // 强制下行
                    disp_data_right1 <= 9'h100 | ((run_timer_ms/1000) % 10); // 秒钟数字带小数点
                    disp_data_right0 <= (run_timer_ms/100) % 10;  // 0.1秒精度
                    mem_state <= S_IDLE_1F;
                    led[11:7] <= 5'b00001 << (run_timer_ms / 600); // 也是下行流水方向
                end

                S_IDLE_1F: begin
                    disp_data_right3 <= 8'h1; disp_data_right2 <= SEG_IDLE;
                    disp_data_right1 <= 9'h100 | 9'h0; // 静止楼也强制加点小数点
                    disp_data_right0 <= 8'h0; 
                    req_down <= 0; led[2] <= 0; led[0] <= 0; // 清除下楼记忆对应的灯
                    mem_state <= S_IDLE_1F;
                    led[11:7] <= 5'b0; 
                end

                S_IDLE_2F: begin
                    disp_data_right3 <= 8'h2; disp_data_right2 <= SEG_IDLE;
                    disp_data_right1 <= 9'h100 | 9'h0; // 同理加点
                    disp_data_right0 <= 8'h0; 
                    req_up <= 0; led[3] <= 0; led[1] <= 0;   // 清除上楼记忆对应的灯
                    mem_state <= S_IDLE_2F;
                    led[11:7] <= 5'b0; 
                end

                S_MOVE_UP: begin
                    // 上行时数显前2秒起楼，后1秒显目楼
                    disp_data_right3 <= (run_timer_ms < 2000) ? 8'h1  : 8'h2; disp_data_right2 <= SEG_UP;
                    disp_data_right1 <= 9'h100 | ((run_timer_ms/1000) % 10); 
                    disp_data_right0 <= (run_timer_ms/100) % 10;  

                    // 上行灯依次点亮
                    led[11:7] <= 5'b10000 >> (run_timer_ms / 600); // 3000ms / 600 = 5个阶段
                end

                S_MOVE_DOWN: begin
                    // 下行时数显前2秒起楼，后1秒显目楼
                    disp_data_right3 <= (run_timer_ms < 2000) ? 8'h2  : 8'h1; disp_data_right2 <= SEG_DOWN;
                    disp_data_right1 <= 9'h100 | ((run_timer_ms/1000) % 10); 
                    disp_data_right0 <= (run_timer_ms/100) % 10;  

                    // 下行灯依次点亮
                    led[11:7] <= 5'b00001 << (run_timer_ms / 600); // 3000ms / 600 = 5个阶段
                end

                S_DOOR_2F: begin
                    // 到站等待显示
                    // 在此靠站停留3秒并开门倒计时
                    req_up <= 0; led[3] <= 0; led[1] <= 0; disp_data_right3 <= 8'h2; disp_data_right2 <= SEG_IDLE;
                    disp_data_right1 <= 9'h100 | (((2999 - run_timer_ms)/1000) % 10); // 倒数2.9s -> 0.0s
                    disp_data_right0 <= ((2999 - run_timer_ms)/100) % 10;  
                    led[11:7] <= 5'b00000;
                end

                S_DOOR_1F: begin
                    // 到站等待显示(1楼开门控
                    req_down <= 0; led[2] <= 0; led[0] <= 0; disp_data_right3 <= 8'h1; disp_data_right2 <= SEG_IDLE;
                    disp_data_right1 <= 9'h100 | (((2999 - run_timer_ms)/1000) % 10); 
                    disp_data_right0 <= ((2999 - run_timer_ms)/100) % 10;  
                    led[11:7] <= 5'b00000;
                end
            endcase
            
            // 硬件复位清除残余请求
            if (!rst_n) begin
                req_up <= 0; req_down <= 0; led[3:0] <= 0; led[15:14] <= 0;
            end
        end
    end

    
endmodule


