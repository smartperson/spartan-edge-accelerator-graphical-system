`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2020 09:41:44 PM
// Design Name: 
// Module Name: spi_ram_controller
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


module spi_ram_controller(
    input  wire clk,
    input  wire [3:0] i_qspi_din,
    input  wire i_qspi_cs,
    input  wire i_qspi_clk,
    output wire [13:0] o_ram_addr,
    output wire [15:0] o_ram_data,
    output wire o_ram_write
    );
    
    spi_receiver spi_receiver_1 (
        .dev_clk(clk),
        .clk  (i_qspi_clk),
        .q    (i_qspi_din[0]),
        .d    (i_qspi_din[1]),
        .cs   (i_qspi_cs),
        .wp   (i_qspi_din[2]),
        .hd   (i_qspi_din[3]),
        .o_data (i_ram_data),
        .o_data_ready (spi_pulse)
    );
    enum {idle, latched_addr, wait_data, latched_data, write_data, increment_pause, increment_addr} state, next_state; 
    reg [2:0] read_cycles = 0;
    reg [13:0] reg_ram_addr;
    reg [13:0] next_addr;
    reg [15:0] reg_ram_data;
    wire [15:0] i_ram_data;
    wire spi_pulse;
    reg reg_ram_write = 0;

    // logic for next state
    always @(posedge clk) begin : curr_state_regs 
        unique if (i_qspi_cs == 1)
            state <= idle;
        else
            state <= next_state;
    end : curr_state_regs
    
    always_comb begin : next_state_logic
        next_state <= state; // default is to stay in current state
        unique case (state)
            idle            : begin if (spi_pulse) next_state <= latched_addr; else next_state <= idle; end 
//            wait_addr       : ;
//            read_addr       : ;
            latched_addr    : next_state <= wait_data;
            wait_data       : if (spi_pulse) next_state <= latched_data; //begin if (spi_pulse) next_state <= latched_data; else next_state <= wait_data; end
//            read_data       : ;
            latched_data    : next_state <= write_data;
            write_data      : next_state <= increment_pause;
            increment_pause : next_state <= increment_addr;
            increment_addr  : next_state <= wait_data;
        endcase
    end : next_state_logic
    
//    always @(spi_pulse, i_qspi_cs) begin: output_regs
//        if (spi_pulse && state == idle) begin
//            reg_ram_addr = i_ram_data;
//            next_state   = wait_data;  
//        end else if (spi_pulse && state == wait_data) begin
//            reg_ram_data  = i_ram_data;
//            next_state    = latched_data;
//            reg_ram_write = 0;
//        end else if (!spi_pulse && state == latched_data) begin
//            reg_ram_write = 1;
//            next_state    = idle;
//        end else if (i_qspi_cs) begin
//            reg_ram_write = 0;
//            next_state    = idle;
//        end else
//            next_state = state;
//    end: output_regs
    reg [1:0] reg_pause_counter;
    always @(state) begin: output_regs
        unique case (state)
            idle            : begin
                                reg_ram_addr <= 0;
                                //next_addr <= 0;
                                reg_ram_data <= 0;
                                reg_ram_write <= 0;
                              end
            latched_addr    : begin reg_ram_addr <= i_ram_data; end
            wait_data       : begin
                                next_addr <= reg_ram_addr + 1;
                              end
            latched_data    : begin
                                reg_ram_data <= i_ram_data;
                              end
            write_data      : begin reg_ram_write <= 1; end
            increment_pause : begin reg_ram_write <= 0; end
            increment_addr  : begin
                                reg_ram_addr <= next_addr;
                                ;
//                                reg_ram_addr <= next_addr;
                              end
        endcase
    end: output_regs

    
    assign o_ram_write = reg_ram_write;
    assign o_ram_addr  = reg_ram_addr;
    assign o_ram_data  = reg_ram_data;
    
    /* What do we need to do here?
    * Reset state when CS is done
    * First two bytes we get during transaction are the target (RAM?) address -- just RAM to start.
    * Later the consumers of information from this controller might be smarter, and handle non-RAM (register) data.
    * Load up two bytes of data
    * Assert o_ram_write to let memory systems know that we have set up the correct address and data, and RAM should be written to
    * Reset o_ram_write
    * Increment the target address
    ** Just by 1 address location for now. Later consider more elaborate DMA architectures whee we can do fancy math and auto increment or decrement by other measures than just 1 word.
    */
endmodule
