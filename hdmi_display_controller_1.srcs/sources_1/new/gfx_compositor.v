module gfx_compositor (
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    input wire i_pix_clk,
    input wire i_esp32,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue
    );
    
    wire bg_hit, sprite_hit;
    wire [7:0] bg_red;
    wire [7:0] bg_green;
    wire [7:0] bg_blue;
    wire [7:0] sprite_red;
    wire [7:0] sprite_green;
    wire [7:0] sprite_blue;
    
    wire [15:0] ram_data;
    wire ram_write;
    wire [14:0] ram_addr;
    wire [15:0] load_data;
    
    /*simple_ram simple_ram_1 (
        .i_din(ram_data),
        .i_we (ram_write),
        .i_addr(ram_addr),
        .i_clk(i_pix_clk),
        .o_dout(load_data)
    );*/
    blk_mem_0 simple_ram_1 (
        .clka(i_pix_clk),    // input wire clka
        .ena(1),      // input wire ena
        .wea(0),      // input wire [1 : 0] wea
        .addra(ram_addr),  // input wire [14 : 0] addra
        .dina(ram_data),    // input wire [15 : 0] dina
        .douta(load_data)  // output wire [15 : 0] douta
    );
    
    bg_compositor #( .RAM_READ_START_CYCLE(5'b10011) ) bg_compositor_1 ( //11001
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .i_pix_clk  (i_pix_clk),
        .i_in_data  (load_data),
        .o_addr     (ram_addr),
        .o_red      (bg_red),
        .o_green    (bg_green),
        .o_blue     (bg_blue),
        .o_bg_hit   (bg_hit)
    );
    
    sprite_compositor sprite_compositor_1 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .i_esp32    (i_esp32),
        .o_red      (sprite_red),
        .o_green    (sprite_green),
        .o_blue     (sprite_blue),
        .o_sprite_hit   (sprite_hit)
    );
    
    reg [7:0] reg_red, reg_green, reg_blue;
    always @(posedge i_pix_clk) begin
        reg_red <= sprite_hit? sprite_red : bg_red;
        reg_green <= sprite_hit ? sprite_green : bg_green;
        reg_blue <= sprite_hit ? sprite_blue : bg_blue;
    end
    assign o_red = reg_red;
    assign o_green = reg_green;
    assign o_blue = reg_blue;
endmodule