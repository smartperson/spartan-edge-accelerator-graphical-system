`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2020 10:11:54 PM
// Design Name: 
// Module Name: simple_ram
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

/*
Address range 	Size 	Description
$0000-$0FFF 	$1000 	Pattern table 0
$1000-$1FFF 	$1000 	Pattern table 1
$2000-$23FF 	$0400 	Nametable 0
$2400-$27FF 	$0400 	Nametable 1
$2800-$2BFF 	$0400 	Nametable 2
$2C00-$2FFF 	$0400 	Nametable 3
$3000-$3EFF 	$0F00 	Mirrors of $2000-$2EFF
$3F00-$3F1F 	$0020 	Palette RAM indexes
$3F20-$3FFF 	$00E0 	Mirrors of $3F00-$3F1F 

PPU addresses within the pattern tables can be decoded as follows:

DCBA98 76543210
---------------
0HRRRR CCCCPTTT
|||||| |||||+++- T: Fine Y offset, the row number within a tile
|||||| ||||+---- P: Bit plane (0: "lower"; 1: "upper")
|||||| ++++----- C: Tile column
||++++---------- R: Tile row
|+-------------- H: Half of sprite table (0: "left"; 1: "right")
+--------------- 0: Pattern table is at $0000-$1FFF



*/
module simple_ram(
    i_din, i_we, i_addr, i_clk, o_dout
    );
    parameter data_width=16, address_width=15,mem_elements=20480;
    input [data_width-1:0] i_din;
    input [address_width-1:0] i_addr;
    input wire i_we, i_clk;
    output [data_width-1:0] o_dout;
    reg [data_width-1:0] mem[mem_elements-1:0];
    // Exemplar attribute mem block_ram FALSE
    
    /* Use the directive above ONLY if you want to disable Block RAM extraction.
    Set the block_ram attribute to FALSE on the signal memory.
    The block_ram attribute must be set on the memory signal. */
    
    reg [address_width - 1:0] addr_reg;
    reg [data_width-1:0] data_reg;
    //assign addr_reg = i_addr;
    always @(posedge i_clk)
    begin
        data_reg <= mem[i_addr];
        if (i_we) mem[i_addr] <= i_din;
    end    
    assign o_dout = data_reg;
     
    parameter MEM_INIT_FILE = "ram_data.hex";
    initial begin
        if (MEM_INIT_FILE != "") begin
            $readmemh(MEM_INIT_FILE, mem);
        end
    end
    
endmodule
