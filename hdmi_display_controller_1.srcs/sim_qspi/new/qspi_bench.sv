`timescale 1ns / 1ps
`default_nettype none

module qspi_bench();
    reg qspi_cs;
    reg qspi_clk;
    reg [3:0] qspi_data;
    //code up an interesting bench for qspi_clk, and qspi_data[3:0]
    always
    begin
        qspi_cs = 1;
        qspi_clk = 0;
        qspi_data = 4'b0000;
        #20
        qspi_cs = 0;
        #20
        qspi_data = 4'h3;
        qspi_clk = 1;
        #10
        qspi_clk = 0;
        #10
        qspi_data = 4'hE;
        qspi_clk = 1;
                #10
        qspi_clk = 0;
        #10
        qspi_data = 4'hA;
        qspi_clk = 1;
        #10
        qspi_clk = 0;
        #10
        qspi_data = 4'hF;
        qspi_clk = 1;
        #10
        qspi_clk = 0;
        #10
        qspi_data = 4'h0;
        qspi_clk = 1;
        #10
        qspi_clk = 0;
        #10
        qspi_data = 4'h1;
        qspi_clk = 1;
        #10
        qspi_clk = 0;
        #10
        qspi_data = 4'h2;
        qspi_clk = 1;
        #10
        qspi_clk = 0;
        #10
        qspi_data = 4'h3;
        qspi_clk = 1;
        #10
        qspi_clk = 0;
        #10
        qspi_data = 4'h4;
        qspi_clk = 1;
        #10
        qspi_clk = 0;
        #10
        qspi_data = 4'h5;
        qspi_clk = 1;
        #10
        qspi_clk = 0;
        #10
        qspi_data = 4'h6;
        qspi_clk = 1;
        #10
        qspi_clk = 0;
        #10
        qspi_data = 4'h7;
        qspi_clk = 1;
        #10
        qspi_clk = 0;
        #10
        qspi_data = 4'h0;
        #20
        qspi_cs = 1;
    end
    
    reg clk = 0;
    initial begin
        clk = 0;
        qspi_data = 0;
        qspi_clk = 0;
        qspi_cs = 1;
    end
    
    always
    begin
        #5
        clk = ~clk;
    end
    //connect it up to our RAM component hierarchy
    
    wire [13:0] dma_addr;
    wire [15:0] dma_data;
    wire        dma_we;
    
    spi_ram_controller spi_ram_controller_1 (
        .clk (clk),
        .i_qspi_din ({qspi_data[3], qspi_data[2], qspi_data[0], qspi_data[1]}),
        .i_qspi_cs  (qspi_cs),
        .i_qspi_clk (qspi_clk),
        .o_ram_addr (dma_addr),
        .o_ram_data (dma_data),
        .o_ram_write(dma_we)
    );
    //read and validate the signals that come out of our RAM controller
endmodule