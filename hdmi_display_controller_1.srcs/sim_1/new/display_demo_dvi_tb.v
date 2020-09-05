`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2020 09:10:13 PM
// Design Name: 
// Module Name: display_demo_dvi_tb
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


module display_demo_dvi_tb();
    
    reg clk;

    display_demo_dvi display_demo_test (
    .CLK(clk),                // board clock: 100 MHz on Arty/Basys3/Nexys
    .RST_BTN(1),            // reset button
    .esp32_in(1)           // HACK input pin from ESP32
//    input  wire btn_user1,           // HACK input pin from ESP32
//    inout  wire hdmi_tx_cec,        // CE control bidirectional
//    input  wire hdmi_tx_hpd,        // hot-plug detect
//    inout  wire hdmi_tx_rscl,       // DDC bidirectional
//    inout  wire hdmi_tx_rsda,       // DDC bidirectional
//    output wire hdmi_tx_clk_n,      // HDMI clock differential negative
//    output wire hdmi_tx_clk_p,      // HDMI clock differential positive
//    output wire [2:0] hdmi_tx_n,    // Three HDMI channels differential negative
//    output wire [2:0] hdmi_tx_p     // Three HDMI channels differential positive
    );

    initial begin
        clk <= 1;
    end

    always
       #5 clk = ~clk;

endmodule
