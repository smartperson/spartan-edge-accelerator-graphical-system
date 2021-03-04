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

//    reg [15:0] sprite_x     = 16'd00;
//    reg [15:0] sprite_y     = 16'd00;
    reg sprite_y_flip       = 0;
    wire sprite_hit_x, sprite_hit_y;
    reg [2:0] sprite_render_x;
    reg [2:0] sprite_render_y;

    reg [15:0] i_x, i_y;
    reg [13:0] x_scroll = 1698; //NOTE: change this to experiment with craziness
    reg [9:0] y_scroll = (RAM_MAP_ADDR == 15'h2000) ? 304 : 304;
    reg y_dir = 0; //0 go up, 1 go down
    reg [3:0] counter;

    assign i_x = i_x_raw + x_scroll;
    assign i_y = (i_y_raw + y_scroll)%1024;
//    assign i_x = i_x_raw + x_scroll;

    reg curr_tile_index;
//    assign curr_tile_index = (((i_x+1) & 31) >= (x_scroll & 31)) ? 1 : 0;

    always @(posedge i_v_sync) begin
        if (RAM_MAP_ADDR == 15'h2000) begin
            if (y_scroll == 0)
                y_dir <= 1;
            else if (y_scroll == 1024-720)
                y_dir <= 0;
            counter <= counter+2;
        end
        else begin
            if (y_scroll == 152)
                y_dir <= 1;
            else if (y_scroll == 304)
                y_dir <= 0;
            counter <= counter+1;
        end
    end
    reg x_dir = 1;
    always @(posedge counter[1]) begin //@(posedge i_y_raw[0]) begin
        if (x_scroll == 1700)
          x_dir <= 0;
        else if (x_scroll == 1698)
            x_dir <= 1;
        y_scroll <= y_scroll + (y_dir ? +1: -1);
        //x_scroll <= x_scroll + (x_dir ? +1: -1);
        x_scroll <= x_scroll+1;
    end

//    always @(posedge i_y_raw[0]) begin
//        if (RAM_MAP_ADDR == 15'h2000)
//            if (x_scroll < 2048)
//                x_scroll <= x_scroll+1;
//            else
//                x_scroll <= 0;
//    end

    localparam base_red     = 8'h00;
    localparam base_green   = 8'h10;
    localparam base_blue    = 8'h4C;

    assign o_red    = base_red + i_y + {2'b0, i_x};
    assign o_green  = base_green + i_y;
    assign o_blue   = base_blue + i_y;
    assign o_bg_hit = 1;

endmodule
