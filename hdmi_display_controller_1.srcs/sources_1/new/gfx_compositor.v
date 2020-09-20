module gfx_compositor (
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
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
    
    bg_compositor bg_compositor_1 (
        .i_x        (i_x),
        .i_y        (i_y),
        .o_red      (bg_red),
        .o_green    (bg_green),
        .o_blue     (bg_blue),
        .o_bg_hit   (bg_hit)
    );
    
    sprite_compositor sprite_compositor_1 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red),
        .o_green    (sprite_green),
        .o_blue     (sprite_blue),
        .o_sprite_hit   (sprite_hit)
    );
    
    assign o_red = sprite_hit? sprite_red : bg_red;
    assign o_green = sprite_hit ? sprite_green : bg_green;
    assign o_blue = sprite_hit ? sprite_blue : bg_blue;

endmodule