// File: ./build/Loopback.v
// Generated by MyHDL 0.10
// Date: Mon Dec 10 13:16:24 2018


`timescale 1ns/10ps

module Loopback (
    clk_i,
    rst_i,
    rx_i,
    tx_o,
    anodos_o,
    segmentos_o
);


input clk_i;
input rst_i;
input rx_i;
output tx_o;
reg tx_o;
output [3:0] anodos_o;
reg [3:0] anodos_o;
output [7:0] segmentos_o;
reg [7:0] segmentos_o;

wire [8:0] value;
wire [7:0] dat;
reg tx_start;
reg tx_ready;
reg [0:0] state;
reg rx_ready;
wire [7:0] rx_dat;
wire full;
reg enqueue;
wire empty;
reg dequeue;
reg UART0_tx_tick;
reg UART0_rx_tick;
reg [5:0] UART0_clk_div0_counter8;
reg [2:0] UART0_clk_div0_counter;
reg [0:0] UART0_uart_tx0_state;
reg [7:0] UART0_uart_tx0_data;
reg [3:0] UART0_uart_tx0_cnt;
reg [1:0] UART0_uart_rx0_state;
reg [2:0] UART0_uart_rx0_rx_sync;
wire UART0_uart_rx0_rx_r;
reg UART0_uart_rx0_nxt_bit;
reg [7:0] UART0_uart_rx0_dat_r;
reg [1:0] UART0_uart_rx0_bit_start;
reg [2:0] UART0_uart_rx0_bit_spacing;
reg [2:0] UART0_uart_rx0_bit_cnt;
reg [7:0] FIFO0_ram_dat_o;
reg [7:0] FIFO0_enqueue_ptr;
reg [7:0] FIFO0_dequeue_ptr;
wire FIFO0__full;
wire FIFO0__enqueue;
wire FIFO0__empty;
wire FIFO0__dequeue;
reg [8:0] FIFO0__count;
reg driver7seg0_tick;
reg [3:0] driver7seg0_thousand;
reg [3:0] driver7seg0_ten;
reg [3:0] driver7seg0_one;
reg [3:0] driver7seg0_hundred;
reg [17:0] driver7seg0_counter;
reg [3:0] driver7seg0_anodos;
reg [7:0] FIFO0_RAM_DP0__ram [0:256-1];
reg [24:0] driver7seg0_bin2bcd0_shift [0:10-1];



always @(posedge clk_i) begin: LOOPBACK_UART0_CLK_DIV0_COUNTER_PROC
    if (rst_i == 1) begin
        UART0_clk_div0_counter <= 0;
    end
    else begin
        if ((UART0_clk_div0_counter8 == 0)) begin
            UART0_clk_div0_counter <= (UART0_clk_div0_counter + 1);
        end
    end
end


always @(posedge clk_i) begin: LOOPBACK_UART0_CLK_DIV0_COUNTER16_PROC
    if (rst_i == 1) begin
        UART0_clk_div0_counter8 <= 0;
    end
    else begin
        if (($signed({1'b0, UART0_clk_div0_counter8}) == (54 - 1))) begin
            UART0_clk_div0_counter8 <= 0;
        end
        else begin
            UART0_clk_div0_counter8 <= (UART0_clk_div0_counter8 + 1);
        end
    end
end


always @(posedge clk_i) begin: LOOPBACK_UART0_CLK_DIV0_UART_TICK_PROC
    if (rst_i == 1) begin
        UART0_tx_tick <= 0;
        UART0_rx_tick <= 0;
    end
    else begin
        UART0_rx_tick <= (UART0_clk_div0_counter8 == 0);
        UART0_tx_tick <= ((UART0_clk_div0_counter == 0) && UART0_rx_tick);
    end
end


always @(posedge clk_i) begin: LOOPBACK_UART0_UART_TX0_TX_STATE_M
    if (rst_i == 1) begin
        UART0_uart_tx0_cnt <= 0;
        UART0_uart_tx0_data <= 0;
        UART0_uart_tx0_state <= 1'b0;
        tx_o <= 0;
        tx_ready <= 0;
    end
    else begin
        case (UART0_uart_tx0_state)
            1'b0: begin
                tx_ready <= 1;
                if (tx_start) begin
                    UART0_uart_tx0_data <= dat;
                    tx_ready <= 0;
                    UART0_uart_tx0_state <= 1'b1;
                end
                else begin
                    tx_o <= 1;
                end
            end
            1'b1: begin
                if (UART0_tx_tick) begin
                    if (((UART0_uart_tx0_cnt >= 1) && (UART0_uart_tx0_cnt <= 8))) begin
                        tx_o <= UART0_uart_tx0_data[0];
                        UART0_uart_tx0_data <= {1'b0, UART0_uart_tx0_data[8-1:1]};
                        UART0_uart_tx0_cnt <= (UART0_uart_tx0_cnt + 1);
                    end
                    else begin
                        tx_o <= 0;
                        UART0_uart_tx0_cnt <= (UART0_uart_tx0_cnt + 1);
                    end
                    if ((UART0_uart_tx0_cnt == 9)) begin
                        tx_o <= 1;
                        tx_ready <= 1;
                        UART0_uart_tx0_state <= 1'b0;
                        UART0_uart_tx0_cnt <= 0;
                    end
                end
            end
            default: begin
                UART0_uart_tx0_state <= 1'b0;
            end
        endcase
    end
end


always @(posedge clk_i) begin: LOOPBACK_UART0_UART_RX0_RX_SYNC_PROC
    if (rst_i == 1) begin
        UART0_uart_rx0_rx_sync <= 7;
    end
    else begin
        if (UART0_rx_tick) begin
            UART0_uart_rx0_rx_sync <= {UART0_uart_rx0_rx_sync[2-1:0], rx_i};
        end
    end
end



assign UART0_uart_rx0_rx_r = ((UART0_uart_rx0_rx_sync == 7) || (UART0_uart_rx0_rx_sync == 3) || (UART0_uart_rx0_rx_sync == 5) || (UART0_uart_rx0_rx_sync == 6));
assign rx_dat = UART0_uart_rx0_dat_r;


always @(posedge clk_i) begin: LOOPBACK_UART0_UART_RX0_NXT_BIT_PROC
    if (rst_i == 1) begin
        UART0_uart_rx0_nxt_bit <= 0;
        UART0_uart_rx0_bit_spacing <= 0;
    end
    else begin
        UART0_uart_rx0_nxt_bit <= ($signed({1'b0, UART0_uart_rx0_bit_spacing}) == (8 - 1));
        if ((UART0_rx_tick && (UART0_uart_rx0_state != 2'b00))) begin
            UART0_uart_rx0_bit_spacing <= (UART0_uart_rx0_bit_spacing + 1);
        end
    end
end


always @(posedge clk_i) begin: LOOPBACK_UART0_UART_RX0_START_BIT_PROC
    if (rst_i == 1) begin
        UART0_uart_rx0_bit_start <= 0;
    end
    else begin
        if (((UART0_uart_rx0_state == 2'b00) && (!UART0_uart_rx0_rx_r))) begin
            UART0_uart_rx0_bit_start <= (UART0_uart_rx0_bit_start + UART0_rx_tick);
        end
        else begin
            UART0_uart_rx0_bit_start <= 0;
        end
    end
end


always @(posedge clk_i) begin: LOOPBACK_UART0_UART_RX0_FSM_PROC
    if (rst_i == 1) begin
        UART0_uart_rx0_state <= 2'b00;
        UART0_uart_rx0_dat_r <= 0;
        rx_ready <= 0;
        UART0_uart_rx0_bit_cnt <= 0;
    end
    else begin
        rx_ready <= 1'b0;
        if (UART0_rx_tick) begin
            case (UART0_uart_rx0_state)
                2'b00: begin
                    if (((!UART0_uart_rx0_rx_r) && (UART0_uart_rx0_bit_start == 2'h3))) begin
                        UART0_uart_rx0_state <= 2'b01;
                    end
                end
                2'b01: begin
                    if (UART0_uart_rx0_nxt_bit) begin
                        UART0_uart_rx0_dat_r <= {UART0_uart_rx0_rx_r, UART0_uart_rx0_dat_r[8-1:1]};
                        UART0_uart_rx0_bit_cnt <= (UART0_uart_rx0_bit_cnt + 1);
                        if ((UART0_uart_rx0_bit_cnt == 7)) begin
                            UART0_uart_rx0_state <= 2'b10;
                        end
                    end
                end
                2'b10: begin
                    if (UART0_uart_rx0_nxt_bit) begin
                        UART0_uart_rx0_state <= 2'b00;
                        rx_ready <= 1'b1;
                    end
                end
                default: begin
                    UART0_uart_rx0_state <= 2'b00;
                end
            endcase
        end
    end
end


always @(posedge clk_i) begin: LOOPBACK_FIFO0_RAM_DP0_RAM_PROC
    if (FIFO0__enqueue) begin
        FIFO0_RAM_DP0__ram[FIFO0_enqueue_ptr] <= rx_dat;
    end
    FIFO0_ram_dat_o <= FIFO0_RAM_DP0__ram[FIFO0_dequeue_ptr];
end



assign value = FIFO0__count;
assign empty = FIFO0__empty;
assign full = FIFO0__full;
assign dat = FIFO0__empty ? rx_dat : FIFO0_ram_dat_o;



assign FIFO0__empty = (FIFO0__count == 0);
assign FIFO0__full = FIFO0__count[8];



assign FIFO0__enqueue = ((!FIFO0__full) && enqueue);
assign FIFO0__dequeue = ((!FIFO0__empty) && dequeue);

// verilator lint_off WIDTH 
always @(posedge clk_i) begin: LOOPBACK_FIFO0_ADDR_PTR_PROC
    if (rst_i == 1) begin
        FIFO0__count <= 0;
        FIFO0_dequeue_ptr <= 0;
        FIFO0_enqueue_ptr <= 0;
    end
    else begin
        FIFO0_enqueue_ptr <= (FIFO0_enqueue_ptr + FIFO0__enqueue);
        FIFO0_dequeue_ptr <= (FIFO0_dequeue_ptr + FIFO0__dequeue);
        FIFO0__count <= ((FIFO0__count + FIFO0__enqueue) - FIFO0__dequeue);
        // verilator lint_on WIDTH 
    end
end

// verilator lint_off WIDTH 
always @(posedge clk_i) begin: LOOPBACK_DRIVER7SEG0_BIN2BCD0_DECOMP_PROC
    integer i;
    integer thousand;
    integer hundred;
    integer ten;
    integer one;
    if (rst_i == 1) begin
        driver7seg0_bin2bcd0_shift[0] <= 0;
        driver7seg0_bin2bcd0_shift[1] <= 0;
        driver7seg0_bin2bcd0_shift[2] <= 0;
        driver7seg0_bin2bcd0_shift[3] <= 0;
        driver7seg0_bin2bcd0_shift[4] <= 0;
        driver7seg0_bin2bcd0_shift[5] <= 0;
        driver7seg0_bin2bcd0_shift[6] <= 0;
        driver7seg0_bin2bcd0_shift[7] <= 0;
        driver7seg0_bin2bcd0_shift[8] <= 0;
        driver7seg0_bin2bcd0_shift[9] <= 0;
    end
    else begin
        driver7seg0_bin2bcd0_shift[0] <= value;
        for (i=0; i<9; i=i+1) begin
            thousand = (driver7seg0_bin2bcd0_shift[i][(9 + 16)-1:(9 + 12)] + 3);
            hundred = (driver7seg0_bin2bcd0_shift[i][(9 + 12)-1:(9 + 8)] + 3);
            ten = (driver7seg0_bin2bcd0_shift[i][(9 + 8)-1:(9 + 4)] + 3);
            one = (driver7seg0_bin2bcd0_shift[i][(9 + 4)-1:9] + 3);
            driver7seg0_bin2bcd0_shift[(i + 1)] <= ({(driver7seg0_bin2bcd0_shift[i][(9 + 16)-1:(9 + 12)] < 5) ? driver7seg0_bin2bcd0_shift[i][(9 + 16)-1:(9 + 12)] : thousand[4-1:0], (driver7seg0_bin2bcd0_shift[i][(9 + 12)-1:(9 + 8)] < 5) ? driver7seg0_bin2bcd0_shift[i][(9 + 12)-1:(9 + 8)] : hundred[4-1:0], (driver7seg0_bin2bcd0_shift[i][(9 + 8)-1:(9 + 4)] < 5) ? driver7seg0_bin2bcd0_shift[i][(9 + 8)-1:(9 + 4)] : ten[4-1:0], (driver7seg0_bin2bcd0_shift[i][(9 + 4)-1:9] < 5) ? driver7seg0_bin2bcd0_shift[i][(9 + 4)-1:9] : one[4-1:0], driver7seg0_bin2bcd0_shift[i][9-1:0]} << 1);
        end
        // verilator lint_on WIDTH 
    end
end


always @(posedge clk_i) begin: LOOPBACK_DRIVER7SEG0_BIN2BCD0_ASSIGN_PROC
    if (rst_i == 1) begin
        driver7seg0_thousand <= 0;
        driver7seg0_ten <= 0;
        driver7seg0_one <= 0;
        driver7seg0_hundred <= 0;
    end
    else begin
        driver7seg0_thousand <= driver7seg0_bin2bcd0_shift[9][(9 + 16)-1:(9 + 12)];
        driver7seg0_hundred <= driver7seg0_bin2bcd0_shift[9][(9 + 12)-1:(9 + 8)];
        driver7seg0_ten <= driver7seg0_bin2bcd0_shift[9][(9 + 8)-1:(9 + 4)];
        driver7seg0_one <= driver7seg0_bin2bcd0_shift[9][(9 + 4)-1:9];
    end
end


always @(posedge clk_i) begin: LOOPBACK_DRIVER7SEG0_CNT_ANODOS_PROC
    if (rst_i == 1) begin
        driver7seg0_tick <= 0;
        driver7seg0_counter <= 0;
    end
    else begin
        if (($signed({1'b0, driver7seg0_counter}) == (208333 - 1))) begin
            driver7seg0_counter <= 0;
            driver7seg0_tick <= 1'b1;
        end
        else begin
            driver7seg0_counter <= (driver7seg0_counter + 1);
            driver7seg0_tick <= 1'b0;
        end
    end
end


always @(posedge clk_i) begin: LOOPBACK_DRIVER7SEG0_ANODOS_PROC
    if (rst_i == 1) begin
        driver7seg0_anodos <= 1;
    end
    else begin
        if (driver7seg0_tick) begin
            driver7seg0_anodos <= {driver7seg0_anodos[3-1:0], driver7seg0_anodos[3]};
        end
    end
end


always @(driver7seg0_ten, driver7seg0_thousand, driver7seg0_anodos, driver7seg0_one, driver7seg0_hundred) begin: LOOPBACK_DRIVER7SEG0_SEGMENTOS_PROC
    anodos_o = driver7seg0_anodos;
    case (driver7seg0_anodos)
        'h1: begin
            case (driver7seg0_one)
                0: segmentos_o = 3;
                1: segmentos_o = 159;
                2: segmentos_o = 37;
                3: segmentos_o = 13;
                4: segmentos_o = 153;
                5: segmentos_o = 73;
                6: segmentos_o = 65;
                7: segmentos_o = 31;
                8: segmentos_o = 1;
                9: segmentos_o = 9;
                10: segmentos_o = 17;
                11: segmentos_o = 193;
                12: segmentos_o = 99;
                13: segmentos_o = 133;
                14: segmentos_o = 97;
                default: segmentos_o = 113;
            endcase
        end
        'h2: begin
            case (driver7seg0_ten)
                0: segmentos_o = 3;
                1: segmentos_o = 159;
                2: segmentos_o = 37;
                3: segmentos_o = 13;
                4: segmentos_o = 153;
                5: segmentos_o = 73;
                6: segmentos_o = 65;
                7: segmentos_o = 31;
                8: segmentos_o = 1;
                9: segmentos_o = 9;
                10: segmentos_o = 17;
                11: segmentos_o = 193;
                12: segmentos_o = 99;
                13: segmentos_o = 133;
                14: segmentos_o = 97;
                default: segmentos_o = 113;
            endcase
        end
        'h4: begin
            case (driver7seg0_hundred)
                0: segmentos_o = 3;
                1: segmentos_o = 159;
                2: segmentos_o = 37;
                3: segmentos_o = 13;
                4: segmentos_o = 153;
                5: segmentos_o = 73;
                6: segmentos_o = 65;
                7: segmentos_o = 31;
                8: segmentos_o = 1;
                9: segmentos_o = 9;
                10: segmentos_o = 17;
                11: segmentos_o = 193;
                12: segmentos_o = 99;
                13: segmentos_o = 133;
                14: segmentos_o = 97;
                default: segmentos_o = 113;
            endcase
        end
        'h8: begin
            case (driver7seg0_thousand)
                0: segmentos_o = 3;
                1: segmentos_o = 159;
                2: segmentos_o = 37;
                3: segmentos_o = 13;
                4: segmentos_o = 153;
                5: segmentos_o = 73;
                6: segmentos_o = 65;
                7: segmentos_o = 31;
                8: segmentos_o = 1;
                9: segmentos_o = 9;
                10: segmentos_o = 17;
                11: segmentos_o = 193;
                12: segmentos_o = 99;
                13: segmentos_o = 133;
                14: segmentos_o = 97;
                default: segmentos_o = 113;
            endcase
        end
        default: begin
            segmentos_o = 255;
        end
    endcase
end


always @(posedge clk_i) begin: LOOPBACK_L_STATE_M
    if (rst_i == 1) begin
        tx_start <= 0;
        dequeue <= 0;
        state <= 1'b0;
        enqueue <= 0;
    end
    else begin
        if ((state == 1'b1)) begin
            if ((full || (rx_dat == 10))) begin
                tx_start <= 1'b0;
                enqueue <= 1'b0;
                state <= 1'b1;
            end
        end
        else if ((state == 1'b1)) begin
            if (tx_ready) begin
                dequeue <= 1'b1;
                tx_start <= 1'b1;
            end
            if (rx_ready) begin
                enqueue <= 1'b1;
            end
            if (empty) begin
                dequeue <= 1'b0;
            end
        end
        else begin
            state <= 1'b0;
        end
    end
end

endmodule