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
set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports esp_qspi_d]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports esp_qspi_clk]
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports esp_qspi_cs]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports esp_qspi_q]
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS33} [get_ports esp_qspi_hd]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports esp_qspi_wp]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {esp_qspi_clk_IBUF}]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets esp_qspi_cs_IBUF]

create_debug_core u_ila_0 ila

#connect_debug_port u_ila_0/probe3 [get_nets [list esp_qspi_hd_IBUF]]
#connect_debug_port u_ila_0/probe4 [get_nets [list esp_qspi_q_IBUF]]
#connect_debug_port u_ila_0/probe5 [get_nets [list esp_qspi_wp_IBUF]]


set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list pix_clk_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {gfx_compositor_inst/spi_receiver_1/reg_spi_data[0]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[1]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[2]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[3]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[4]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[5]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[6]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list esp_qspi_clk_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list esp_qspi_cs_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list esp_qspi_d_IBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets pix_clk_BUFG]
