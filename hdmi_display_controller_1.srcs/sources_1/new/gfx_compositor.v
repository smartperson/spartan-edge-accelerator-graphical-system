module gfx_compositor (
    input wire clk,
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    input wire i_pix_clk,
    input wire i_esp32,
    input wire i_btn,
    input wire qspi_clk,
    input wire qspi_d,
    input wire qspi_q,
    input wire qspi_cs,
    input wire qspi_wp,
    input wire qspi_hd,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue
    );
    
    wire bg_hit_0, bg_hit_1, sprite_hit;
    wire [3:0] bg_color_0;
    wire [2:0] bg_palette_0;
    wire [3:0] bg_color_1;
    wire [2:0] bg_palette_1;
    wire [7:0] sprite_red;
    wire [7:0] sprite_green;
    wire [7:0] sprite_blue;
    
    wire [15:0] ram_data;
    wire ram_write;
    wire ram_enable_0, ram_enable_1;
    wire [14:0] ram_addr, ram_addr_0, ram_addr_1;
    reg [14:0] reg_ram_addr;
    wire [15:0] load_data;
    
    localparam [0:15][0:15][2:0][7:0] cg_palettes =  {
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

    wire [15:0] dma_addr;
    wire [15:0] dma_data;
    wire dma_we;

    always @* //combinatorial clockless
    begin
        if (ram_enable_0)
            reg_ram_addr <= ram_addr_0;
        else if (ram_enable_1)
            reg_ram_addr <= ram_addr_1;
        else if (dma_we) begin
            reg_ram_addr <= dma_addr;
            end
    end
    assign ram_addr = reg_ram_addr;
    reg [7:0] reg_spi_data;
    
    blk_mem_0 simple_ram_1 (
        .clka(i_pix_clk),    // input wire clka
        .ena(1),      // input wire ena
        .wea(dma_we && i_y>720),      // input wire [1 : 0] wea
        .addra(ram_addr),  // input wire [14 : 0] addra
        .dina(dma_data),    // input wire [15 : 0] dina
        .douta(load_data)  // output wire [15 : 0] douta
    );
    
    bg_compositor #( .RAM_READ_START_CYCLE(5'b10000), .RAM_MAP_ADDR(15'h2800) ) bg_compositor_0 ( //11001
        .i_x_raw        (i_x),
        .i_y_raw        (i_y),
        .i_v_sync   (i_v_sync),
        .i_pix_clk  (i_pix_clk),
        .i_in_data  (load_data),
        .o_ram_enable (ram_enable_0),
        .o_addr     (ram_addr_0),
        .o_palette      (bg_palette_0),
        .o_color    (bg_color_0),
        .o_priority   (bg_hit_0)
    );
    
    bg_compositor #( .RAM_READ_START_CYCLE(5'b11000), .RAM_MAP_ADDR(15'h2000) ) bg_compositor_1 ( //11001
        .i_x_raw          (i_x),
        .i_y_raw          (i_y),
        .i_v_sync     (i_v_sync),
        .i_pix_clk    (i_pix_clk),
        .i_in_data    (load_data),
        .i_btn      (i_esp32),
        .o_ram_enable (ram_enable_1),
        .o_addr       (ram_addr_1),
        .o_palette    (bg_palette_1),
        .o_color      (bg_color_1),
        .o_priority   (bg_hit_1)
    );
    
    sprite_compositor sprite_compositor_1 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .i_esp32    (reg_spi_data && 8'b11111111),
        .o_red      (sprite_red),
        .o_green    (sprite_green),
        .o_blue     (sprite_blue),
        .o_sprite_hit   (sprite_hit)
    );
    
    spi_ram_controller spi_ram_controller_1 (
        .clk (clk),
        .i_qspi_din ({qspi_hd, qspi_wp, qspi_d, qspi_q}),
        .i_qspi_cs  (qspi_cs),
        .i_qspi_clk (qspi_clk),
        .o_ram_addr (dma_addr),
        .o_ram_data (dma_data),
        .o_ram_write(dma_we)
    );
    
    reg [7:0] reg_red, reg_green, reg_blue;
    //hack to add dma_we just so that synthesis keeps our variable and we can capture it in the ILA
    assign reg_red = sprite_hit? sprite_red :      ( (bg_color_1 == 0) ? cg_palettes[bg_palette_0][bg_color_0][2] : cg_palettes[bg_palette_1][bg_color_1][2] );
    assign reg_green = sprite_hit ? sprite_green : ( (bg_color_1 == 0) ? cg_palettes[bg_palette_0][bg_color_0][1] : cg_palettes[bg_palette_1][bg_color_1][1] );
    assign reg_blue = sprite_hit ? sprite_blue :   ( (bg_color_1 == 0) ? cg_palettes[bg_palette_0][bg_color_0][0] : cg_palettes[bg_palette_1][bg_color_1][0] );

    assign o_red = reg_red;
    assign o_green = reg_green;
    assign o_blue = reg_blue;
endmodule