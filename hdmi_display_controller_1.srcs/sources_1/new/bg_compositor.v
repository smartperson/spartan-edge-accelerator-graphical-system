`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2020 01:10:06 AM
// Design Name: 
// Module Name: bg_compositor
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


module bg_compositor(
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue,
    output wire o_bg_hit
    );
    
    localparam base_red     = 8'h00;
    localparam base_green   = 8'h10;
    localparam base_blue    = 8'h4C;

    assign o_red    = base_red + i_y + {2'b0, i_x};
    assign o_green  = base_green + i_y;
    assign o_blue   = base_blue + i_y;
    assign o_bg_hit = 1;
    
endmodule
