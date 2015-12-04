#!/bin/bash

function error {
	echo "[!] There was an error!";
	exit;
}

echo "Compiling bootloader...";
nasm -f bin -o core/boot.bin core/boot.asm || error
echo "[+] Bootloader compiled with result core/boot.bin";

echo "Compiling kernel...";
nasm -f bin -o core/kernel.bin core/kernel.asm || error;
echo "[+] Kernel compiled with result core/kernel.bin"

echo "Compiling shell...";
nasm -f bin -o core/sh.bin core/sh.asm || error;
echo "[+] Shell compiled with result core/sh.bin"

arg=("$@");

if [ "${arg[0]}" = "images" ]; then
	echo "Creating Stix image...";
	hdiutil create images/Stix.dmg -megabytes 1.44 -type UDIF || error;
	echo "[+] Image created with result images/Stix.dmg";
	
	echo "Creating temporary local mount point...";
	mkdir mnt;
	echo "[+] Local mount point created with result ./mnt";

	echo "Writing bootloader to disk...";
	dd conv=notrunc if=core/boot.bin of=images/Stix.dmg || error;
	echo "[+] Bootloader written to image";

	echo "Attempting mount of new disk...";
	disk=`hdid -nobrowse -nomount images/Stix.dmg`;
	mount ${disk} mnt || error;
	echo "[+] Disk mounted with result images/Stix.dmg -> ./mnt";

	echo "Writing kernel to image...";
	cp core/kernel.bin mnt/ || error;
	echo "[+] Kernel written to mounted image with result ./mnt/kernel.bin";

	echo "Unmounting image...";
	umount ${disk} & hdiutil detach ${disk} || error;
	echo "[+] Image unmounted";

	echo "Writing mountable image to bootable floppy image...";
	dd conv=notrunc if=images/Stix.dmg of=images/Stix.flp || error;
	echo "[+] New image created with result images/Stix.dmg -> images/Stix.flp";

	echo "Cleaing up...";
	rm -t mnt || error;
	echo "[-] Build cleaned up";
	
	echo "Build complete, run \`qemu -fda images/Stix.flp\` to boot";
else
	echo "The bootloader, kernel, and shell have been compiled. Run \`./build.sh images\` to create bootable disk images.";
fi

