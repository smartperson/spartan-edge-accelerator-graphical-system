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
    input wire dev_clk, //fpga clock (100MHz?)
    input wire d, //mosi
    input wire clk,
    input wire q, //miso
    input wire cs,
    input wire wp, //qio
    input wire hd, //qio
    output wire [15:0] o_data,
    output wire o_data_ready
    );
    reg [4:0] bit_counter = 0;
    reg [15:0] tmp = 0;
    reg [15:0] reg_data = 0;
    reg [1:0] pulse_counter = 0;
    reg data_ready, data_pulse = 0;
    reg prev_ready = 0;
    reg reset_ready = 0;
    
    // sync SCK to the FPGA clock using a 3-bits shift register
    reg [2:0] SCKr;  always @(posedge dev_clk) SCKr <= {SCKr[1:0], SCK};
    wire SCK_risingedge = (SCKr[2:1]==2'b01);  // now we can detect SCK rising edges
    wire SCK_fallingedge = (SCKr[2:1]==2'b10);  // and falling edges
    
    // same thing for SSEL
    reg [2:0] SSELr;  always @(posedge dev_clk) SSELr <= {SSELr[1:0], SSEL};
    wire SSEL_active = ~SSELr[1];  // SSEL is active low
    wire SSEL_startmessage = (SSELr[2:1]==2'b10);  // message starts at falling edge
    wire SSEL_endmessage = (SSELr[2:1]==2'b01);  // message stops at rising edge
    
    // and for MOSI
    reg [1:0] MOSIr;  always @(posedge dev_clk) MOSIr <= {MOSIr[0], MOSI};
    wire MOSI_data = MOSIr[1];

    // we handle SPI in 8-bits format, so we need a 3 bits counter to count the bits as they come in
    reg [2:0] bitcnt;
    
    reg byte_received;  // high when a byte has been received
    reg [7:0] byte_data_received;

    always @(posedge dev_clk)
    begin
      if(~SSEL_active)
        bitcnt <= 3'b000;
      else
      if(SCK_risingedge)
      begin
        bitcnt <= bitcnt + 3'b100;
    
        // implement a shift-left register (since we receive the data MSB first)
        byte_data_received <= {byte_data_received[6:0], MOSI_data};
      end
    end
    
    always @(posedge (clk | cs)) 
    begin 
      if (~cs) 
        begin 
          data_ready <= 0;
          if (reset_ready) bit_counter[4] <= 0;
          tmp = tmp << 4; 
          tmp[3] <= hd;
          tmp[2] <= wp;
          tmp[1] <= q;
          tmp[0] <= d;
          bit_counter <= bit_counter+4;
          if(bit_counter[4]) data_ready<=1;
        end 
      else
        begin
          bit_counter <= 0;
          reset_ready <= 0;
          data_ready <= 0;
         end  
    end 
    
    always @(posedge dev_clk) byte_received <= SSEL_active && SCK_risingedge && (bitcnt==3'b100); //i think we signal on 3'b100 because the next cycle will give us all 8 bits?
    
    assign o_data = reg_data;
    assign o_data_ready = data_ready;
    
endmodule