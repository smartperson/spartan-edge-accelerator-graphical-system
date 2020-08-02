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


module bg_compositor
    #( parameter  RAM_READ_START_CYCLE    = 5'b11001 )
    (
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    input wire i_pix_clk,
    input wire [15:0] i_in_data,
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
    wire [2:0] sprite_render_x;
    wire [2:0] sprite_render_y;
    
    localparam [0:15][0:15][2:0][7:0] palette_colors =  {
        384'hDFDFDFE8F0F800581020680040780060880088A000A8B80098E0E0000000D8381858F85898E0E0000000E8F0F8F85858,
        384'hDFDFDFE8F0F8F8F8F800000000B8F800C8F800E0F800F8F898E0E000000058A8F0F8F8F898E0E0000000D8A038F8D870,
        384'hDFDFDFE8F0F8000000786818C89858007848E0C05000C800000000F8F8F800000000C800B00000F80000F85800F8A000,
        384'hDFDFDFE8F0F8000000585858787878989898C0C0C0E0E0E0000000F8F8F800000000C800E81868F040A8F878C8F8C0F0,
        384'hDFDFDFE8F0F8707070000000C0C0C0A0C8F8A8E0F8C0F8F8000000F8F8F800000000C80000E00088F838C8F800F8F898,
        384'hDFDFDFE8F0F8000000B8A860D8F8C800800000C80000F800000000000000000000000000000000000000000000000000,
        384'hDFDFDFE8F0F8000000885818F808F8D8A038F8D820F8F800000000000000000000000000000000000000000000000000,
        384'hDFDFDFE8F0F8000000B80050F800804848886868B08080C8000000000000000000000000000000000000000000000000,
        384'hDFDFDFF8F8F8000000885818D8A038F8D870F8D0C0E800B0500000F8407020308840809880D8C8B02860F87068F8F800,
        384'hDFDFDFF8F8F8000000707070A0A0A0C0C0C0E0E0E0F81058000000F8F8F800000000C800B00000F80000F85800F8A000,
        384'hDFDFDFF8F8F8000000F87800F8C000F8F800B82800F88800000000F8F8F800000000C800E81868F040A8F878C8F8C0F0,
        384'hDFDFDFF8F8F80000004040D86868D88888F8B82800F88800000000F8F8F800000000C80000E00088F838C8F800F8F898,
        384'hDFDFDFF8F8F8000000880000B80000F80000B82800F88800000000000000000000000000000000000000000000000000,
        384'hDFDFDFF8F8F800000000780000B80000F800B82800F88800000000000000000000000000000000000000000000000000,
        384'hDFDFDFF8F8F8000000283048485058686858989040C0C078000000000000000000000000000000000000000000000000,
        384'hDFDFDFF8F8F818484820706828887830A08838B898F80080000000000000000000000000000000000000000000000000
    };
    
    assign sprite_hit_x = 1;
    assign sprite_hit_y = 1;
    
    assign sprite_render_x = i_x[4:2];
    assign sprite_render_y = i_y[4:2];
    reg [2:0] selected_palette;
    reg [3:0] selected_color;

    reg [14:0]reg_addr;
    //reg [15:0]reg_ram;
    reg [9:0]reg_tile_number;
    reg [7:0]reg_tile_attr;
    reg [5:0]reg_next_tile_attrs;
    reg [0:31] reg_next_tile;
    reg [0:31] reg_curr_tile;
    wire [1:0]x_attr_bits;
    assign x_attr_bits = i_x[6:5];
    always @(negedge i_pix_clk) begin
        case (i_x[4:0])
            5'b11111: begin
                sprite_y_flip <= reg_next_tile_attrs[5];
                sprite_x_flip <= reg_next_tile_attrs[4];
                // bit 3 has priority, figure out how/what to assign it to here
            end
        endcase
        if (sprite_x_flip)
            selected_color <= {reg_curr_tile[(7-sprite_render_x)+24], reg_curr_tile[(7-sprite_render_x)+16], reg_curr_tile[(7-sprite_render_x)+8], reg_curr_tile[(7-sprite_render_x)]};
        else
            selected_color <= {reg_curr_tile[sprite_render_x+24], reg_curr_tile[sprite_render_x+16], reg_curr_tile[sprite_render_x+8], reg_curr_tile[sprite_render_x]};
    end
    always @(negedge i_pix_clk) begin
        case (i_x[4:0])
//            5'b10111: reg_addr <= 0;//15'h23C0 + (i_x == 16'b1111111111110111 ? i_y[15:5]*10 : (((i_x[15:5]+1)>>2) + i_y[15:5]*10));
//            5'b11000: ; //reg_next_tile_attr <= 0;//i_in_data;
            RAM_READ_START_CYCLE: begin
                if (i_x[10])
                    reg_addr <= 15'h2400 | (i_y[15:5]*32 + i_x[9:5]/*+1*/);
                else
                    reg_addr <= 15'h2000 | (i_x == 16'b1111111111111001 ? i_y[15:5]*32 : (i_y[15:5]*32 + i_x[15:5]/*+1*/));
            end
            RAM_READ_START_CYCLE+1: begin
                reg_tile_number <= i_in_data[9:0];
                reg_next_tile_attrs <= i_in_data[15:10];
            end
            RAM_READ_START_CYCLE+2: begin
                if (reg_next_tile_attrs[5])
                    reg_addr <= 15'b000000000000000 + (reg_tile_number*16) + (7-sprite_render_y);
                else
                    reg_addr <= 15'b000000000000000 + (reg_tile_number*16) + sprite_render_y;
            end
            RAM_READ_START_CYCLE+3: reg_next_tile[0:15] <= i_in_data;
            RAM_READ_START_CYCLE+4: begin
                if (reg_next_tile_attrs[5])
                    reg_addr <= 15'b000000000000000 + (reg_tile_number*16) + (7 -sprite_render_y + 8);
                else
                    reg_addr <= 15'b000000000000000 + (reg_tile_number*16) + sprite_render_y + 8;
            end
            RAM_READ_START_CYCLE+5: reg_next_tile[16:31] <= i_in_data;
            5'b11111: begin //this one should always be done on the last clock cycle for the tile
                reg_curr_tile <= reg_next_tile;
            end
            default: ; 
        endcase
    end
    assign o_addr   = reg_addr;
//    assign o_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][selected_color][2] : 8'hXX;
//    assign o_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][selected_color][1] : 8'hXX;
//    assign o_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][selected_color][0] : 8'hXX;
    reg [7:0] reg_red, reg_green, reg_blue;
    assign o_red    = reg_red;
    assign o_green  = reg_green;
    assign o_blue   = reg_blue;
    assign o_bg_hit = 1;
    always @(posedge i_pix_clk) begin
        reg_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][selected_color][2] : 8'hXX;
        reg_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][selected_color][1] : 8'hXX;
        reg_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][selected_color][0] : 8'hXX;
        if (i_x[4:0] == 5'b11111)
            selected_palette <= reg_next_tile_attrs[2:0];
    end
endmodule
