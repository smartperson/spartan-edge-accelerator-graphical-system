`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2020 09:25:44 PM
// Design Name: 
// Module Name: spi_receiver
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


module spi_receiver(
    input wire dev_clk,
    input wire d, //mosi
    input wire clk,
    input wire q, //miso
    input wire cs,
    input wire wp, //qio
    input wire hd, //qio
    output wire [15:0] o_data,
    output wire o_data_ready
    );
    reg [3:0] bit_counter = 0;
    reg [15:0] tmp = 0;
    reg [15:0] reg_data = 0;
    reg [1:0] pulse_counter = 0;
    reg data_ready, data_pulse = 0;
    reg prev_ready = 0;
    reg reset_ready = 0;

    always @(posedge clk) 
    begin 
      if (~cs) 
        begin 
          tmp = tmp << 4; 
          tmp[3] <= hd;
          tmp[2] <= wp;
          tmp[1] <= q;
          tmp[0] <= d;
          bit_counter = bit_counter+4;
        end 
      else
        bit_counter = 0;
    end 
    
    reg prev_ready;
    always @(negedge clk) begin //latch when we got the 16th bit
        //data_ready = 0;
      if (bit_counter == 8'b0000) begin//8th (2 cycles, 4 bits each!)
        reg_data = tmp;
      end
    end 

//    always @(posedge dev_clk) begin
//        if (data_pulse) pulse_counter <= pulse_counter+1;
//    end
//    always @(posedge dev_clk) begin
//        prev_ready = data_ready;
//        if (bit_counter == 8'b0000 && !data_ready && !clk && reset_ready) begin //8th (2 cycles, 4 bits each!)
//            data_ready = 1;
//            reset_ready = 0;
//        end
//        else if (clk) begin
//            data_ready = 0;
//            reset_ready = 1;
//        end else
//            data_ready = 0;
        
//    end

//    reg prev_pulse;
//    always @(posedge dev_clk) begin
//        prev_pulse = data_pulse;
//        if (data_ready && !prev_ready && !prev_pulse) data_pulse = 1; //invert current/prev logic?
//        else data_pulse = 0;
//    end
    always @(posedge dev_clk) begin
        if (bit_counter == 8'b0000 && !clk && reset_ready) begin //8th (2 cycles, 4 bits each!)
            data_ready = 1;
            reset_ready = 0;
        end
        else if (pulse_counter == 2'b11) begin
            data_ready = 0;
            pulse_counter = 0;
        end
        else if (clk)
            reset_ready = 1;
        else
            data_ready = 0;
            
        if (data_ready)
            pulse_counter = pulse_counter+1;
    end
    
    assign o_data = reg_data;
    assign o_data_ready = data_ready;
    
endmodule