# spartan-edge-accelerator-graphical-system
WIP Graphics layer and inter IC communication for the Spartan Edge Accelerator fpga/mcu hybrid board

## What is the Spartan Edge Accelerator?

![](https://github.com/SeeedDocument/Spartan-Edge-Accelerator-Board/raw/master/img/Spartan-Edge-Accelerater-Board-v1.0-wiki.jpg)

The folks at [Seeed Studio](https://www.seeedstudio.com/Spartan-Edge-Accelerator-Board-p-4261.html) released an FPGA development board. 
It includes a Xilinx Spartan 7 FPGA and an ESP32 chip. It includes multiple types of IO (USB, Grove, HDMI, MIPI CSI, microSD, and more.
Though the board was designed as an Arduino shield, it contains plenty of interesting hardware, and Seeed also bills it as an environment to learn FPGA development.

## What is this project?

Seeed doesn't provide any information on using the ESP32 as an application processor. They only meant for that chip to start up, load the bitstream into the FPGA,
and then act as a wireless/bluetooth peripheral for an attached Arduino. I'm not interested in that. The ESP32 is a capable microcontroller on its own, but it's not fast
enough to drive an HD display on its own.

That's where the FPGA comes in. I want the Spartan 7 on this board to provide graphics capabilities for programs running on the ESP32.

## Key capabilities

This is project is very much a work in progress. However current or desired key capabilities. The projects and issues on this repo document the work
that remains to get something workable.

* Minimum 720p60 over HDMI
* Other high definition LCDs connected over parallel or serial
* 8-/16-bit style graphics support
* Multiple display sprites
* Scrollable background layers
* Dynamically modifying all VRAM data from the running ESP32 program

## Screenshot

![](http://varunmehta.com/raw/sea-fpga-demo.jpg)

## Key limitations

Limitations are extremely numerous at this time. Resolutions higher than 1080p are likely impossible over HDMI, as the clock speed is too high for the XC7S15 to
generate.

## Build & Usage Requirements

* Vivado Webpack 2019.1 or newer
* Spartan Edge Accelerator (NB: I have so far only tested uploading the bitstream via JTAG)
* HDMI display
* An Arduino/ESP-IDF Program that will toggle GPIO27 in order to make the sprite move. This is temporary.

## TODO

This document requires more instruction on how to configure and customize the graphics, as they are, for your own uses.
Technical TODOs are already documented as issues.
