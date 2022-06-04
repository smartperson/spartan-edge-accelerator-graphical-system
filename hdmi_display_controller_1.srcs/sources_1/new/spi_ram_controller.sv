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

    wire [15:0] i_ram_data;
    wire cs_rising;
    wire spi_pulse;

    spi_receiver spi_receiver_1 (
        .dev_clk (clk),
        .clk  (i_qspi_clk),
        .q    (i_qspi_din[0]),
        .d    (i_qspi_din[1]),
        .cs   (i_qspi_cs),
        .wp   (i_qspi_din[2]),
        .hd   (i_qspi_din[3]),
        .o_data (i_ram_data),
        .o_data_ready (spi_pulse),
        .cs_rising (cs_rising)
    );
    enum {idle, latched_addr, wait_data, latched_data, increment_addr} state, next_state;
    reg [13:0] reg_ram_addr;
    reg [13:0] next_addr;
    reg [15:0] reg_ram_data;
    reg reg_ram_write = 0;

    // logic for next state
    //TODO: adjust the behaviors/signals we look for from the spi_receiver since now our state machine is
    // once again running of the device clk instead of the esp32's spi clk. We cannot just assume every clock cycle that we should increment.
    //DONE? also check for the appropriate reset condition. use the clock synchronized signals for qspi cs. I think that's the only one that's needed.
//    always @(posedge clk) begin : curr_state_regs
//        if (cs_rising)
//            state = idle;
//        else
//            state = next_state;
//    end : curr_state_regs

//    reg [1:0] reg_pause_counter;
//    always @(state) begin: output_regs
//        unique case (state)
//            idle            : begin
//                                reg_ram_addr <= 0;
//                                next_addr <= 0; //these are really needed, but I want to see if there is some kind of reset that's happening to this state that is causing the signals to get reset
//                                reg_ram_data <= 0;
//                                reg_ram_write <= 0;
//                              end
//            latched_addr    : begin
//                                reg_ram_addr[13:0] <= i_ram_data[13:0];
//                                next_addr <= i_ram_data[13:0];
//                                reg_ram_data <= 0;
//                                reg_ram_write <= 0;
//                              end
//            wait_data       : begin
//                                reg_ram_addr <= reg_ram_addr;
//                                next_addr <= reg_ram_addr;
//                                reg_ram_data <= 0;
//                                reg_ram_write <= 0;
//                              end
//            latched_data    : begin
//                                reg_ram_addr <= reg_ram_addr;
//                                next_addr <= reg_ram_addr + 1;
//                                reg_ram_data <= i_ram_data;
//                                reg_ram_write <= 1;
//                              end
//            increment_addr  : begin
//                                reg_ram_addr <= next_addr;
//                                next_addr <= next_addr;
//                                reg_ram_data <= 0;
//                                reg_ram_write <= 0;
//                              end
//            default         : begin
//                                reg_ram_addr <= reg_ram_addr;
//                                next_addr <= next_addr;
//                                reg_ram_data <= reg_ram_data;
//                                reg_ram_write <= reg_ram_write;
//                              end
//        endcase
//    end: output_regs

    always @(posedge clk) begin : curr_state_regs
        if (cs_rising)
            state = idle;
        else
            state = next_state;
    end : curr_state_regs

    always_comb begin : next_state_logic
        //next_state = state; // default is to stay in current state
        unique case (state)
            idle            : begin if (spi_pulse) next_state = latched_addr; else next_state = idle; end
            latched_addr    : begin next_state = wait_data; end
            wait_data       : begin
                                if (spi_pulse) next_state = latched_data;
                                else next_state = wait_data; //begin if (spi_pulse) next_state <= latched_data; else next_state <= wait_data;
                              end
            latched_data    : begin next_state = increment_addr; end
            increment_addr  : begin if (spi_pulse) next_state = latched_data; else next_state=increment_addr; end
            default         : next_state = state;
        endcase
    end : next_state_logic

// TODO: Separate the state controls (next_state), logic/output controls (assign_variable = 1), and actual actions (variable = variable2)
// next_state and output controls can use the same sensitivity list probably (state)
// actual actions should use clk as sensitivity
//    always @(state, spi_pulse, i_ram_data, reg_ram_addr, next_addr, reg_ram_write, reg_ram_data) begin: output_regs
      always @(posedge clk) begin: output_regs
        unique case (state)
            idle            : begin
                                reg_ram_addr = 0;
                                next_addr = 0;
                                reg_ram_data = 0;
                                reg_ram_write = 0;
                              end
            latched_addr    : begin
                                reg_ram_addr[13:0] = i_ram_data[13:0];
                                next_addr[13:0] = i_ram_data[13:0];
                                reg_ram_data = 0;
                                reg_ram_write = 0;
                              end
            wait_data       : begin
                                reg_ram_addr = reg_ram_addr;
                                next_addr = reg_ram_addr;
                                reg_ram_data = 0;
                                reg_ram_write = 0;
                              end
            latched_data    : begin
                                reg_ram_addr = reg_ram_addr;
                                next_addr = reg_ram_addr + 1;
                                reg_ram_data = i_ram_data;
                                reg_ram_write = 1;
                              end
            increment_addr  : begin
                                reg_ram_addr = next_addr;
                                next_addr = next_addr;
                                reg_ram_data = 0;
                                reg_ram_write = 0;
                              end
//            default         : begin
//                                next_state <= state;
//                                reg_ram_addr <= reg_ram_addr;
//                                next_addr <= next_addr;
//                                reg_ram_data <= reg_ram_data;
//                                reg_ram_write <= reg_ram_write;
//                              end
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
