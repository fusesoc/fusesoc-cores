wb_gpio
======

wb_gpio is a simple 8-bit GPIO core with a Wishbone interface for control and status. 
Each GPIO pin can be set as an input or output independent of the other pins.

- Register 0 [7:0] : GPIO Data (R/W) bit 7:0
- Register 1 [7:0] : GPIO Direction (0=input, 1=output) bit 7:0
