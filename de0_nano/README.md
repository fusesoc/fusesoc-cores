Bootloader
----------

The de0 nano system is set up by default to start executing at address 0xf0000000 where the boot ROM is located. The contents of the bootloader memory can be set by changing the top-level parameter `bootrom_file` to a different file. Two different bootloaders are shipped with the de0_nano files.

### SPI Flash bootloader

spi_loader program  starts executing from internal Boot ROM. This reads out a binary image stored in the on-board SPI Flash and writes it to SDRAM. For simulations, the contents of the SPI Flash can be set with the `spi_flash_file` parameter

When the program is done loading to RAM, spi_loader will jump to address 0x100 where it expects the first instruction of the program that was copied from the SPI Flash

### Clear R3 and jump to 0x100

The boot ROM will clear registers r0 and r3 and then proceeed to start executing a program from address 0x100. This bootloader is intended for simulation purposes where a program can be preloaded to RAM with the --elf-load=/path/to/elf-file parameter, as well as on target HW where the RAM is initialized with a debugger
