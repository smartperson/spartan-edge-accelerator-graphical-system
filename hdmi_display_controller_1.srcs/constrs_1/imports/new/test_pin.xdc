## Clock signal 100 MHz

set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports CLK]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLK]

##HDMI Tx

# set_property -dict { PACKAGE_PIN E4   IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_cec }]; #IO_L19N_T3_VREF_35 Sch=hdmi_tx_cec
set_property -dict {PACKAGE_PIN F4 IOSTANDARD TMDS_33} [get_ports hdmi_tx_clk_n]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD TMDS_33} [get_ports hdmi_tx_clk_p]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_n[0]}]
set_property -dict {PACKAGE_PIN G1 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_p[0]}]
set_property -dict {PACKAGE_PIN D2 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_n[1]}]
set_property -dict {PACKAGE_PIN E2 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_p[1]}]
set_property -dict {PACKAGE_PIN C1 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_n[2]}]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_p[2]}]
# set_property -dict { PACKAGE_PIN D4   IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_hpd }]; #IO_0_34 Sch=hdmi_tx_hpdn


#    input  wire CLK,                // board clock: 100 MHz on Arty/Basys3/Nexys
#    input  wire RST_BTN,            // reset button
#    inout  wire hdmi_tx_cec,        // CE control bidirectional
#    input  wire hdmi_tx_hpd,        // hot-plug detect
#    inout  wire hdmi_tx_rscl,       // DDC bidirectional
#    inout  wire hdmi_tx_rsda,       // DDC bidirectional
#    output wire hdmi_tx_clk_n,      // HDMI clock differential negative
#    output wire hdmi_tx_clk_p,      // HDMI clock differential positive
#    output wire [2:0] hdmi_tx_n,    // Three HDMI channels differential negative
#    output wire [2:0] hdmi_tx_p     // Three HDMI channels differential positive
#    );

#    wire rst = ~RST_BTN;            // reset is active low on Arty & Nexys Video
#    // wire rst = RST_BTN;          // reset is active high on Basys3 (BTNC)

#    // Display Clocks
#    wire pix_clk;                   // pixel clock
#    wire pix_clk_5x;                // 5x clock for 10:1 DDR SerDes
#    wire clk_lock;                  // clock locked?

set_property IOSTANDARD LVCMOS33 [get_ports hdmi_tx_cec]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_tx_rscl]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_tx_rsda]
set_property IOSTANDARD LVCMOS33 [get_ports RST_BTN]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_tx_hpd]
set_property PACKAGE_PIN D4 [get_ports hdmi_tx_hpd]
set_property PACKAGE_PIN E4 [get_ports hdmi_tx_cec]
set_property PACKAGE_PIN M4 [get_ports RST_BTN]
set_property PACKAGE_PIN F2 [get_ports hdmi_tx_rsda]
set_property PACKAGE_PIN F3 [get_ports hdmi_tx_rscl]
