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


# generic input from ESP32 for fun?
set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports esp32_in]
# input from push button USER1
set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS33} [get_ports btn_user1]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets btn_user1_IBUF]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets esp32_in_IBUF]

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

set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_15]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_14]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_13]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_12]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_11]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_10]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_9]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_8]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_7]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_6]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_5]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_1]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_2]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_3]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_4]
set_property MARK_DEBUG false [get_nets gfx_compositor_inst/bg_compositor_1/n_0_0]

set_property MARK_DEBUG true [get_nets {sx[1]}]
set_property MARK_DEBUG true [get_nets {sx[2]}]
set_property MARK_DEBUG true [get_nets {sx[4]}]
set_property MARK_DEBUG true [get_nets {sx[5]}]
set_property MARK_DEBUG true [get_nets {sx[8]}]
set_property MARK_DEBUG true [get_nets {sx[10]}]
set_property MARK_DEBUG true [get_nets {sx[13]}]
set_property MARK_DEBUG true [get_nets {sx[15]}]
set_property MARK_DEBUG true [get_nets {sx[0]}]
set_property MARK_DEBUG true [get_nets {sx[3]}]
set_property MARK_DEBUG true [get_nets {sx[6]}]
set_property MARK_DEBUG true [get_nets {sx[7]}]
set_property MARK_DEBUG true [get_nets {sx[9]}]
set_property MARK_DEBUG true [get_nets {sx[11]}]
set_property MARK_DEBUG true [get_nets {sx[12]}]
set_property MARK_DEBUG true [get_nets {sx[14]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[0]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[3]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[13]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[2]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[24]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[28]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[5]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[11]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[16]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[18]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[22]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[26]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[9]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[19]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[20]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[21]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[23]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[29]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[8]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[10]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[4]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[7]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[15]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[31]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[1]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[14]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[17]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[27]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[6]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[12]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[25]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/bg_compositor_0/reg_tile_data_reg[0]_4[30]}]
