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

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets esp_qspi_clk_IBUF]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets esp_qspi_cs_IBUF]


#connect_debug_port u_ila_0/probe3 [get_nets [list esp_qspi_hd_IBUF]]
#connect_debug_port u_ila_0/probe4 [get_nets [list esp_qspi_q_IBUF]]
#connect_debug_port u_ila_0/probe5 [get_nets [list esp_qspi_wp_IBUF]]


connect_debug_port u_ila_0/probe0 [get_nets [list {gfx_compositor_inst/spi_receiver_1/reg_spi_data[0]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[1]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[2]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[3]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[4]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[5]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[6]} {gfx_compositor_inst/spi_receiver_1/reg_spi_data[7]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list esp_qspi_clk_IBUF]]
connect_debug_port u_ila_0/probe2 [get_nets [list esp_qspi_cs_IBUF]]
connect_debug_port u_ila_0/probe3 [get_nets [list esp_qspi_d_IBUF]]


set_property MARK_DEBUG false [get_nets gfx_compositor_inst/de]

set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[8]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[13]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[15]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[1]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[3]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[4]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[9]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[10]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[11]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[2]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[6]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[7]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[12]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[0]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[5]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/dma_addr[14]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[4]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[11]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[2]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[3]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[5]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[10]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[12]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[15]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[0]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[8]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[13]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[1]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[6]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[7]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[9]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[14]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[3]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[11]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[1]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[6]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[10]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[13]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[2]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[7]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[9]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[0]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[4]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[5]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[8]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[12]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[14]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[15]}]
set_property MARK_DEBUG true [get_nets gfx_compositor_inst/spi_ram_controller_1/dma_we]
connect_debug_port u_ila_0/probe2 [get_nets [list {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[0]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[1]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[2]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[3]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[4]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[5]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[6]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[7]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[8]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[9]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[10]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[11]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[12]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[13]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[14]} {gfx_compositor_inst/spi_ram_controller_1/reg_ram_data[15]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list gfx_compositor_inst/spi_ram_controller_1/dma_we]]


connect_debug_port u_ila_0/probe3 [get_nets [list {gfx_compositor_inst/spi_ram_controller_1/dma_data[0]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[1]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[2]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[3]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[4]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[5]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[6]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[7]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[8]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[9]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[10]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[11]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[12]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[13]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[14]} {gfx_compositor_inst/spi_ram_controller_1/dma_data[15]}]]

connect_debug_port u_ila_0/probe2 [get_nets [list gfx_compositor_inst/spi_ram_controller_1/reg_ram_write]]


set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/read_cycles[0]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/read_cycles[1]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/read_cycles[2]}]


connect_debug_port u_ila_0/probe1 [get_nets [list {gfx_compositor_inst/dma_addr[0]} {gfx_compositor_inst/dma_addr[1]} {gfx_compositor_inst/dma_addr[2]} {gfx_compositor_inst/dma_addr[3]} {gfx_compositor_inst/dma_addr[4]} {gfx_compositor_inst/dma_addr[5]} {gfx_compositor_inst/dma_addr[6]} {gfx_compositor_inst/dma_addr[7]} {gfx_compositor_inst/dma_addr[8]} {gfx_compositor_inst/dma_addr[9]} {gfx_compositor_inst/dma_addr[10]} {gfx_compositor_inst/dma_addr[11]} {gfx_compositor_inst/dma_addr[12]} {gfx_compositor_inst/dma_addr[13]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/cs]]
connect_debug_port u_ila_0/probe4 [get_nets [list gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/clk]]
connect_debug_port u_ila_0/probe5 [get_nets [list {gfx_compositor_inst/spi_ram_controller_1/state[0]} {gfx_compositor_inst/spi_ram_controller_1/state[1]} {gfx_compositor_inst/spi_ram_controller_1/state[2]}]]
connect_debug_port u_ila_0/probe6 [get_nets [list {gfx_compositor_inst/spi_ram_controller_1/read_cycles[0]} {gfx_compositor_inst/spi_ram_controller_1/read_cycles[1]} {gfx_compositor_inst/spi_ram_controller_1/read_cycles[2]}]]
connect_debug_port u_ila_0/probe7 [get_nets [list gfx_compositor_inst/spi_ram_controller_1/o_ram_write]]

connect_debug_port u_ila_0/probe0 [get_nets [list {u_ila_0_o_data[0]} {u_ila_0_o_data[1]} {u_ila_0_o_data[2]} {u_ila_0_o_data[3]} {u_ila_0_o_data[4]} {u_ila_0_o_data[5]} {u_ila_0_o_data[6]} {u_ila_0_o_data[7]} {u_ila_0_o_data[8]} {u_ila_0_o_data[9]} {u_ila_0_o_data[10]} {u_ila_0_o_data[11]} {u_ila_0_o_data[12]} {u_ila_0_o_data[13]} {u_ila_0_o_data[14]} {u_ila_0_o_data[15]}]]


connect_debug_port u_ila_0/probe0 [get_nets [list gfx_compositor_inst/spi_ram_controller_1/o_data_ready]]
connect_debug_port u_ila_0/probe3 [get_nets [list {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[0]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[1]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[2]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[3]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[4]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[5]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[6]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[7]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[8]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[9]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[10]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[11]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[12]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[13]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[14]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data[15]}]]


connect_debug_port u_ila_0/probe0 [get_nets [list gfx_compositor_inst/spi_ram_controller_1/dma_we]]
connect_debug_port u_ila_0/probe3 [get_nets [list {gfx_compositor_inst/spi_ram_controller_1/Q[0]} {gfx_compositor_inst/spi_ram_controller_1/Q[1]} {gfx_compositor_inst/spi_ram_controller_1/Q[2]} {gfx_compositor_inst/spi_ram_controller_1/Q[3]} {gfx_compositor_inst/spi_ram_controller_1/Q[4]} {gfx_compositor_inst/spi_ram_controller_1/Q[5]} {gfx_compositor_inst/spi_ram_controller_1/Q[6]} {gfx_compositor_inst/spi_ram_controller_1/Q[7]} {gfx_compositor_inst/spi_ram_controller_1/Q[8]} {gfx_compositor_inst/spi_ram_controller_1/Q[9]} {gfx_compositor_inst/spi_ram_controller_1/Q[10]} {gfx_compositor_inst/spi_ram_controller_1/Q[11]} {gfx_compositor_inst/spi_ram_controller_1/Q[12]} {gfx_compositor_inst/spi_ram_controller_1/Q[13]} {gfx_compositor_inst/spi_ram_controller_1/Q[14]} {gfx_compositor_inst/spi_ram_controller_1/Q[15]}]]


connect_debug_port u_ila_0/probe2 [get_nets [list gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/data_pulse_reg_0]]
connect_debug_port u_ila_0/probe3 [get_nets [list gfx_compositor_inst/spi_ram_controller_1/data_pulse_reg]]




connect_debug_port u_ila_0/probe2 [get_nets [list gfx_compositor_inst/spi_ram_controller_1/o_data_ready]]

set_property MARK_DEBUG true [get_nets gfx_compositor_inst/spi_ram_controller_1/o_ram_write]

set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/state[1]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/state[2]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/next_state[1]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/next_state[2]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[1]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[3]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[12]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[14]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[10]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[11]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[13]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[15]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[0]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[4]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[6]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[7]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[9]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[2]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[5]}]
set_property MARK_DEBUG true [get_nets {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_ram_data[8]}]




create_clock -period 12.500 -name esp_qspi_clk -waveform {0.000 6.250} [get_ports esp_qspi_clk]
create_generated_clock -name {display_timings_inst/o_sy[0]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[0]/Q}]
create_generated_clock -name {display_timings_inst/o_sy[1]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[1]/Q}]
create_generated_clock -name {display_timings_inst/o_sy[2]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[2]/Q}]
create_generated_clock -name {display_timings_inst/o_sy[3]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[3]/Q}]
create_generated_clock -name {display_timings_inst/o_sy[4]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[4]/Q}]
create_generated_clock -name {display_timings_inst/o_sy[5]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[5]/Q}]
create_generated_clock -name {display_timings_inst/o_sy[6]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[6]/Q}]
create_generated_clock -name {display_timings_inst/o_sy[7]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[7]/Q}]
create_generated_clock -name {display_timings_inst/o_sy[8]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[8]/Q}]
create_generated_clock -name {display_timings_inst/sy[9]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[9]/Q}]
create_generated_clock -name {display_timings_inst/sy[10]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[10]/Q}]
create_generated_clock -name {display_timings_inst/sy[11]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[11]/Q}]
create_generated_clock -name {display_timings_inst/sy[12]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[12]/Q}]
create_generated_clock -name {display_timings_inst/sy[13]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[13]/Q}]
create_generated_clock -name {display_timings_inst/sy[14]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[14]/Q}]
create_generated_clock -name {display_timings_inst/sy[15]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {display_timings_inst/o_sy_reg[15]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[0] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_1} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[1] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_2} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[2] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_3} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[3] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_4} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[4] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_5} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[5] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_6} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[6] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_7} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[7] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_8} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[8] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_9} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[9] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_10} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[10] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_11} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[11] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_12} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[12] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_13} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[13] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_14} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[14] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_15} -source [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[15] [get_pins {gfx_compositor_inst/bg_compositor_0/counter_reg[1]/Q}]
create_generated_clock -name gfx_compositor_inst/bg_compositor_0/reg_ram_enable_reg_0 -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins gfx_compositor_inst/bg_compositor_0/reg_ram_enable_reg/Q]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[0] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_1} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[1] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_2} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[2] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_3} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[3] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_4} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[4] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_5} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[5] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_6} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[6] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_7} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[7] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_8} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/o_sy[8] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_9} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[9] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_10} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[10] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_11} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[11] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_12} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[12] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_13} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[13] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_14} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[14] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_15} -source [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/C}] -divide_by 1 -add -master_clock display_timings_inst/sy[15] [get_pins {gfx_compositor_inst/bg_compositor_1/counter_reg[1]/Q}]
create_generated_clock -name gfx_compositor_inst/bg_compositor_1/ram_enable_1 -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins gfx_compositor_inst/bg_compositor_1/reg_ram_enable_reg/Q]
create_generated_clock -name {gfx_compositor_inst/spi_ram_controller_1/state[1]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {gfx_compositor_inst/spi_ram_controller_1/state_reg[1]/Q}]
create_generated_clock -name {gfx_compositor_inst/spi_ram_controller_1/state[2]} -source [get_pins display_clocks_inst/MMCME2_BASE_inst/CLKOUT1] -divide_by 1 [get_pins {gfx_compositor_inst/spi_ram_controller_1/state_reg[2]/Q}]
set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_1}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_2}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_3}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_4}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_5}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_6}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_7}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_8}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_9}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_10}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_11}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_12}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_13}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_14}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_0/counter_reg[1]_15}]
set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_1}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_2}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_3}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_4}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_5}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_6}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_7}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_8}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_9}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_10}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_11}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_12}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_13}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_14}] -group [get_clocks -include_generated_clocks {gfx_compositor_inst/bg_compositor_1/counter_reg[1]_15}]




connect_debug_port u_ila_0/probe0 [get_nets [list gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/data_ready]]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list CLK_IBUF]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/o_data_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list esp_qspi_clk_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {gfx_compositor_inst/dma_data[0]} {gfx_compositor_inst/dma_data[1]} {gfx_compositor_inst/dma_data[2]} {gfx_compositor_inst/dma_data[3]} {gfx_compositor_inst/dma_data[4]} {gfx_compositor_inst/dma_data[5]} {gfx_compositor_inst/dma_data[6]} {gfx_compositor_inst/dma_data[7]} {gfx_compositor_inst/dma_data[8]} {gfx_compositor_inst/dma_data[9]} {gfx_compositor_inst/dma_data[10]} {gfx_compositor_inst/dma_data[11]} {gfx_compositor_inst/dma_data[12]} {gfx_compositor_inst/dma_data[13]} {gfx_compositor_inst/dma_data[14]} {gfx_compositor_inst/dma_data[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list gfx_compositor_inst/spi_ram_controller_1/o_ram_write]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 14 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {gfx_compositor_inst/dma_addr[0]} {gfx_compositor_inst/dma_addr[1]} {gfx_compositor_inst/dma_addr[2]} {gfx_compositor_inst/dma_addr[3]} {gfx_compositor_inst/dma_addr[4]} {gfx_compositor_inst/dma_addr[5]} {gfx_compositor_inst/dma_addr[6]} {gfx_compositor_inst/dma_addr[7]} {gfx_compositor_inst/dma_addr[8]} {gfx_compositor_inst/dma_addr[9]} {gfx_compositor_inst/dma_addr[10]} {gfx_compositor_inst/dma_addr[11]} {gfx_compositor_inst/dma_addr[12]} {gfx_compositor_inst/dma_addr[13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 3 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {gfx_compositor_inst/spi_ram_controller_1/state[0]} {gfx_compositor_inst/spi_ram_controller_1/state[1]} {gfx_compositor_inst/spi_ram_controller_1/state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 16 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[0]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[1]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[2]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[3]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[4]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[5]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[6]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[7]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[8]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[9]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[10]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[11]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[12]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[13]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[14]} {gfx_compositor_inst/spi_ram_controller_1/i_ram_data[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 2 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/bit_counter_reg[2]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/bit_counter_reg[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 2 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/pulse_counter[0]} {gfx_compositor_inst/spi_ram_controller_1/spi_receiver_1/pulse_counter[1]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets CLK_IBUF]
