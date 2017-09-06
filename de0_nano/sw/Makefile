BOOTROM_ADDR ?= 0x80000

TARGET ?= spi_uimage_loader
all: $(TARGET).vh

spi_uimage_loader.elf: spi_uimage_loader.S
	or1k-elf-gcc -DBOOTROM_ADDR=$(BOOTROM_ADDR) -nostdlib $< -o $@

%.vh: %.bin
	python ./wb_rom_gen.py $< > $@

%.bin: %.elf
	or1k-elf-objcopy -O binary $< $@

%.elf: %.S
	or1k-elf-gcc -nostdlib $< -o $@

clean:
	rm spi_uimage_loader.elf $(TARGET).vh

