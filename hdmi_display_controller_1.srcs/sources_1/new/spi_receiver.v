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
    input wire d, //mosi
    input wire clk,
    input wire q, //miso
    input wire cs,
    input wire wp, //qio
    input wire hd, //qio
    output wire [7:0] o_data
    );
    reg [2:0] bit_counter;
    reg [7:0] tmp;
    reg [7:0] reg_data;
    always @(posedge clk) 
    begin 
      if (~cs) 
        begin 
          tmp = tmp << 1; 
          tmp[0] = d; 
        end 
    end 
    
    always @(negedge clk) begin //latch when we got the 8th bit
        if (~cs) begin
            if (bit_counter == 8'b111) //8th
                reg_data = tmp;
            bit_counter = bit_counter+1;
        end
    end 
    
    assign o_data = reg_data;
    
endmodule