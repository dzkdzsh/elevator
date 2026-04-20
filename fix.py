import re

file_path = r'D:\course\DigitalSystemsExperiment2\fpga\elevator\elevator_0\elevator_0.srcs\sources_1\new\elevator.v'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# 1. remove sw11 port
text = re.sub(r'^\s*input\s+sw11\s*,\s*//.*\n', '', text, flags=re.MULTILINE)

# 2. change always blocks
text = re.sub(r'always @\(posedge (.+?) or negedge rst_n\)', r'always @(posedge \1)', text)

# 3. clock divider
text = text.replace('''        if (!rst_n) begin
            scan_clk_cnt <= 16'd0;
            scan_clk <= 1'b0;
        end else begin''', '        if (1) begin')

# 4. scan_cnt
text = text.replace('''        if (!rst_n) scan_cnt <= 2'd0;
        else scan_cnt <= (scan_cnt == 2'd3) ? 2'd0 : scan_cnt + 1'b1;''', '''        scan_cnt <= (scan_cnt == 2'd3) ? 2'd0 : scan_cnt + 1'b1;''')

# 5. buttons
text = text.replace('''        if (!rst_n) begin
            btn_temp <= 16'hFFFF;
            btn_reg <= 16'hFFFF;
            btn_reg_last <= 16'hFFFF;
        end else begin''', '        if (1) begin')

# 6. state transition
text = text.replace('''        if (!rst_n) begin
            state <= S_POWER_OFF;
        end else if (!sw11 && state != S_RESET_TO_1F) begin''', '''        if (!rst_n && state != S_RESET_TO_1F) begin''')

# 7. memory logic
text = text.replace('''        if (!rst_n) begin
            run_timer_ms <= 0;
            req_up <= 0; req_down <= 0;
            led <= 16'b0;
            mem_state <= S_IDLE_1F;
            disp_data_right0 <= SEG_OFF;
            disp_data_right1 <= SEG_OFF;
            disp_data_right2 <= SEG_OFF;
        end 
        else begin''', '''        if (1) begin''')

# 8. other sw11 logic
text = text.replace('sw11', 'rst_n')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)

print('Modified successfully!')
