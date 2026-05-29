{
	boot.initrd = {
		kernelModules = [ "dm-snapshot" "cryptd" ];
		luks.devices."cryptroot".device = "/dev/disk/by-label/AetherOS-encrypted";
	};

	fileSystems = {
		"/" = {
			device = "/dev/disk/by-label/AetherOS-root";
			fsType = "ext4";
		};
		"/boot" = {
			device = "/dev/disk/by-label/aether-boot";
			fsType = "vfat";
		};
		# swapDevices = [
		# 	{ device = "/dev/disk/by-label/AetherOS-swap"; }
		# ];
	};
}
