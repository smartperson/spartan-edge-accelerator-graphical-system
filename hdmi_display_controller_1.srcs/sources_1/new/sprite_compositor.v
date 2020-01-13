`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2020 01:10:06 AM
// Design Name: 
// Module Name: sprite_compositor
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


module sprite_compositor(
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue,
    output wire o_sprite_hit
    );
    
    reg [15:0] sprite_x     = 16'd00;
    reg [15:0] sprite_y     = 16'd00;
    reg sprite_x_direction  = 1;
    reg sprite_y_direction  = 1;
    reg sprite_x_flip       = 0;
    reg sprite_y_flip       = 0;
    wire sprite_hit_x, sprite_hit_y;
    wire [3:0] sprite_render_x;
    wire [3:0] sprite_render_y;
    
    localparam [0:3][2:0][7:0] palette_colors =  {
        8'h00, 8'h00, 8'h00,
        8'hFF, 8'h00, 8'h00,
        8'hFF, 8'hFF, 8'hFF,
        8'h21, 8'h21, 8'hFF
        // 8'hFF, 8'h00, 8'h88, 8'h88, 8'h00, 8'hFF, 8'hFF, 8'h00, 8'h88
    };
    
    localparam [0:15][0:15][3:0] sprite_data = {
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd2,4'd2,4'd3,4'd3,4'd1,4'd1,4'd2,4'd2,4'd3,4'd3,4'd0,4'd0,
    4'd0,4'd1,4'd1,4'd1,4'd2,4'd2,4'd3,4'd3,4'd1,4'd1,4'd2,4'd2,4'd3,4'd3,4'd1,4'd0,
    4'd0,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd0,
    4'd0,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd0,
    4'd0,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd0,
    4'd0,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd0,
    4'd0,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd0,
    4'd0,4'd1,4'd1,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd1,4'd1,4'd0,
    4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0 
    };
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 32);
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 32);
    
    assign sprite_render_x = (i_x - sprite_x)>>1;
    assign sprite_render_y = (i_y - sprite_y)>>1;
    wire [1:0] selected_palette;
    assign selected_palette = sprite_x_flip ? (sprite_y_flip ? sprite_data[15-sprite_render_y][15-sprite_render_x]: sprite_data[sprite_render_y][15-sprite_render_x])
                                            : (sprite_y_flip ? sprite_data[15-sprite_render_y][sprite_render_x]   : sprite_data[sprite_render_y][sprite_render_x]);
    
    assign o_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][2] : 8'hXX;
    assign o_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][1] : 8'hXX;
    assign o_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][0] : 8'hXX;
    assign o_sprite_hit = (sprite_hit_y & sprite_hit_x) && (selected_palette != 2'd0);
    
    always @(posedge i_v_sync) begin
        sprite_x <= sprite_x + (sprite_x_direction ? 1 : -1);
        sprite_y <= sprite_y + (sprite_y_direction ? 1 : -1);
        if (sprite_y == 720-32)
            sprite_y_direction <= 0;
        else if (sprite_y <= 1)
            sprite_y_direction <= 1;
        if (sprite_x == 1280-32) begin
            sprite_x_direction <= 0;
            sprite_x_flip <= 1;
        end
        else if (sprite_x <= 1) begin
            sprite_x_direction <= 1;
            sprite_x_flip <= 0;
        end
    end
    
//    localparam [255:0] sprite_data
    
endmodule
