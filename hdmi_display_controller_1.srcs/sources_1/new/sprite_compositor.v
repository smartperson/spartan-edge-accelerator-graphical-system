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
    input wire i_esp32,
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
/*        8'h00, 8'h00, 8'h00,
        8'd216, 8'd41, 8'd0,
        8'd255, 8'd190, 8'd75,
        8'd255, 8'd153, 8'd52*/
        8'h00, 8'h00, 8'h00,
        8'hCF, 8'h00, 8'h00, //  #CF0000
        8'hCE, 8'h9C, 8'h29, //  #CE9C29
        8'h8C, 8'h63, 8'h21  //  #8C6321
        // 8'hFF, 8'h00, 8'h88, 8'h88, 8'h00, 8'hFF, 8'hFF, 8'h00, 8'h88
    };
    
    // 03 07 0F 1F 3F 7F 7F FF 03 07 0F 1F 3F 63 41 C1 top left
    // C0 E0 F0 F8 FC FE FE FF C0 80 00 00 8C FE FE F3 top right
    // FF FF FF 78 00 00 00 00 C1 E3 FF 47 0F 0F 0F 07 bottom left
    // FF FF FF 1E 00 20 20 40 F1 F9 FF E2 F0 F0 F0 E0 bottom right
    
    // 03 07 0F 1F (0,0) -> high(0,0)+high(0,2)
    // 3F 7F 7F FF
    // 03 07 0F 1F
    // 3F 63 41 C1 

    localparam [0:3][0:15][0:7] sprite_data = { //[0:15][0:15][1:0]
    //mushroom 512'h03070F1F3F7F7FFF03070F1F3F6341C1C0E0F0F8FCFEFEFFC08000008CFEFEF3FFFFFF7800000000C1E3FF470F0F0F07FFFFFF1E00202040F1F9FFE2F0F0F0E0
    //jumping small mario
    128'h000307070A0B0C00000000070F0F0F03,
    128'h00E0FC2727113E04070703F7FFFFFEFC,
    128'h3F7F3F0F1F3F7F4F3E7FFFE250387040,
    128'hF8F9F9B7FFFFE000E871014B03030000
    /* pacman ghost 16x16x4bpp 4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
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
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0*/ 
    };
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 64);
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 64);
    
    assign sprite_render_x = (i_x - sprite_x)>>2;
    assign sprite_render_y = (i_y - sprite_y)>>2;
    wire [1:0] selected_palette;
   /* assign selected_palette = sprite_x_flip ? (sprite_y_flip ? sprite_data[7-sprite_render_y][7-sprite_render_x]: sprite_data[sprite_render_y][7-sprite_render_x])
                                            : (sprite_y_flip ? sprite_data[7-sprite_render_y][sprite_render_x]   : sprite_data[sprite_render_y][sprite_render_x]);*/
                                            
    assign selected_palette = {
                                sprite_data[{sprite_render_y[3], sprite_render_x[3]}][sprite_render_y[2:0]+8] [sprite_render_x & 3'b111],
                                sprite_data[{sprite_render_y[3], sprite_render_x[3]}][sprite_render_y[2:0]  ] [sprite_render_x & 3'b111]
                              };
    // (00,00) to (07,07) -> tile 0
    // (08,00) to (15,07) -> tile 1 x is > 0b111
    // (00,08) to (07,15) -> tile 2 y is > 0b111
    // (08,08) to (15,15) -> tile 3 x and y are >0b111
    // 8 1000 + 7 0111 = 15 1111 
    // tile[1:0] = {hy, hx} 
    // x controls the low bit
    // y controls the high bit
    assign o_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][2] : 8'hXX;
    assign o_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][1] : 8'hXX;
    assign o_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][0] : 8'hXX;
    assign o_sprite_hit = (sprite_hit_y & sprite_hit_x) && (selected_palette != 2'd0);
    
    always @(posedge i_v_sync) begin
        if (i_esp32) begin
            sprite_x <= sprite_x + (sprite_x_direction ? 1 : -1); //change to -1 later
            sprite_y <= sprite_y + (sprite_y_direction ? 1 : -1); //change to -1 later
            if (sprite_y == 720-64)
                sprite_y_direction <= 0;
            else if (sprite_y <= 1)
                sprite_y_direction <= 1;
            if (sprite_x == 1280-64) begin
                sprite_x_direction <= 0;
                sprite_x_flip <= 1;
            end
            else if (sprite_x <= 1) begin
            sprite_x_direction <= 1;
            sprite_x_flip <= 0;
            end
        end
    end
    
//    localparam [255:0] sprite_data
    
endmodule
