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
    input wire i_v_sync,
    input wire i_pix_clk,
    input wire [7:0] i_in_data,
    output wire [14:0] o_addr,
    
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue,
    output wire o_bg_hit
    );
    
    reg [15:0] sprite_x     = 16'd00;
    reg [15:0] sprite_y     = 16'd00;
    reg sprite_x_flip       = 0;
    reg sprite_y_flip       = 0;
    wire sprite_hit_x, sprite_hit_y;
    wire [3:0] sprite_render_x;
    wire [3:0] sprite_render_y;
    
    localparam [0:3][0:3][2:0][7:0] palette_colors =  {
        // bg palettes for debugging metatile
        /*96'h000000FFFFFF000000000000,
        96'hFF0000FFFFFFFF0000FF0000,
        96'h00FF00FFFFFF00FF0000FF00,
        96'h0000FFFFFFFF0000FF0000FF*/
        8'hAD, 8'hC6, 8'hFF,
        8'hCE, 8'h9C, 8'h29,
        8'h9C, 8'h39, 8'h00,
        8'h00, 8'h00, 8'h00,
        // bg palette 1
        8'hAD, 8'hC6, 8'hFF,
        8'h7B, 8'hCE, 8'h31,
        8'h29, 8'hBC, 8'h29,
        8'h00, 8'h00, 8'h00,
        // bg palette 2
        8'hAD, 8'hC6, 8'hFF,
        8'hEF, 8'hEF, 8'hEF,
        8'hAD, 8'hDE, 8'hE7,
        8'h00, 8'h00, 8'h00,
        // bg palette 3
        8'hAD, 8'hC6, 8'hFF,
        8'hFF, 8'h00, 8'h00,
        8'h00, 8'hFF, 8'h00,
        8'h00, 8'h00, 8'hFE
    };
    localparam [0:3][0:15][0:7] sprite_data = {
    
    assign sprite_hit_x = 1;//(i_x >= sprite_x) && (i_x < sprite_x + 64);
    assign sprite_hit_y = 1;//(i_y >= sprite_y) && (i_y < sprite_y + 64);
    
    assign sprite_render_x = {1'b0, i_x[4:2]};
    assign sprite_render_y = {1'b0, i_y[4:2]};
    reg [1:0] selected_palette;
    reg [1:0] selected_color;

    reg [14:0]reg_addr;
    reg [7:0]reg_ram;
    reg [7:0]reg_tile_number;
    reg [7:0]reg_tile_attr;
    reg [7:0]reg_next_tile_attr;
    reg [0:15] reg_next_tile;
    reg [0:15] reg_curr_tile;
    wire [1:0]x_attr_bits;
    assign x_attr_bits = i_x[6:5];
    always @(negedge i_pix_clk) begin
        case (x_attr_bits)
            2'b00: selected_palette <= reg_tile_attr[7:6]; //[7:6]
            2'b01: selected_palette <= reg_tile_attr[5:4];//selected_palette <= reg_tile_attr[5:4];
            2'b10: selected_palette <= reg_tile_attr[3:2];//selected_palette <= reg_tile_attr[3:2];
            2'b11: selected_palette <= reg_tile_attr[1:0];//selected_palette <= reg_tile_attr[1:0];
            default: selected_palette <= reg_tile_attr[1:0];
        endcase;
        selected_color <= {reg_curr_tile[8 | (sprite_render_x)], reg_curr_tile[(sprite_render_x)]};
    end
    always @(negedge i_pix_clk) begin
        case (i_x[4:0])
            5'b10111: reg_addr <= 15'h23C0 + (i_x == 16'b1111111111110111 ? i_y[15:5]*10 : (((i_x[15:5]+1)>>2) + i_y[15:5]*10));
            5'b11000: reg_next_tile_attr <= i_in_data;
            5'b11001: reg_addr <= 15'b010000000000000 | (i_x == 16'b1111111111111001 ? i_y[15:5]*40 : (i_x[15:5]+1+i_y[15:5]*40));
            5'b11010: reg_tile_number <= i_in_data;
            5'b11011: reg_addr <= 15'b001000000000000 + (reg_tile_number*16) + sprite_render_y;
            5'b11100: reg_next_tile[0:7] <= i_in_data;
            5'b11101: reg_addr <= 15'b001000000000000 + (reg_tile_number*16) + sprite_render_y + 8;
            5'b11110: reg_next_tile[8:15] <= i_in_data;
            5'b11111: begin
                reg_curr_tile <= reg_next_tile;
                reg_tile_attr <= reg_next_tile_attr;
            end
            default: ; 
        endcase
    end
    assign o_addr   = reg_addr;
    assign o_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][selected_color][2] : 8'hXX;
    assign o_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][selected_color][1] : 8'hXX;
    assign o_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][selected_color][0] : 8'hXX;
    assign o_bg_hit = 1;
endmodule
