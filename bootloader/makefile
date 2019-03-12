boot1_file = boot1
boot1_pos = 0
boot1_size = 1


boot2_file = boot2
boot2_pos = 1
boot2_size = 34

boot3_file = boot3
boot3_pos = 35
boot3_size = 63


boot_disk = disk.img
block_size = 512
disk_size = 128


all: create_disk boot1 boot2 boot3 write_boot1 write_boot3 write_boot2 launch clean
create_disk:
	@dd if=/dev/zero of=$(boot_disk) bs=$(block_size) count=$(disk_size) status=noxfer

boot1:
	@nasm -f bin $(boot1_file).asm -o $(boot1_file).bin

boot2:
	@nasm -f bin $(boot2_file).asm -o $(boot2_file).bin

boot3:
	@nasm -f bin $(boot3_file).asm -o $(boot3_file).bin

write_boot1:
	@dd if=$(boot1_file).bin of=$(boot_disk) bs=$(block_size) seek=$(boot1_pos) count=$(boot1_size) conv=notrunc status=noxfer

write_boot2:
	@dd if=$(boot2_file).bin of=$(boot_disk) bs=$(block_size) seek=$(boot2_pos) count=$(boot2_size) conv=notrunc status=noxfer

write_boot3:
	@dd if=$(boot3_file).bin of=$(boot_disk) bs=$(block_size) seek=$(boot3_pos) count=$(boot3_size) conv=notrunc status=noxfer

launch:
	@qemu-system-i386 -fda $(boot_disk)

clean:
	@rm -f *.bin $(boot_disk) *~
