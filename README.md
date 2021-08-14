# CoreKMS

A minimal Linux system image that runs DHCP, SLAAC and vlmcsd.

Features:

* Less than five megabytes in disk space (If you are using VHD or other formats, the size may be slighly larger. The whole system, however, consumes less than five megabytes.)

* Less than 64 megabytes in memory usage (If you want to support NIC hotplug, that would require up to 128 megabytes of memory.)

* UEFI and BIOS support.

Tech Specs:

* Linux Kernel 5.13

* Buildroot

* musl

* BusyBox Init

* dhcpcd as network manager

Cons:

* Currently there is no way to configure networking manually. All settings are retrieved using DHCP and SLAAC.

* No logging facility. This means that any errors or warnings will be ignored.

* No physical hardware support. This project is mainly used in my own environment, which is basically virtualized, so I only enabled drivers for VirtIO, VirtualBox and Hyper-V in the kernel configuration. If you are planning to install it physically, even though not recommended, you need to enable your drivers, which will eventually lead to a larger kernel.

* Only x86-64 at this time.

## How to build

For legal reasons, I am not providing pre-built binaries at this time.

You need a Linux system to build it. BSD and Cygwin are not tested.

1. Clone the repository including submodules.

2. Enter the `buildroot/` directory.

3. `make -jN BR2_EXTERNAL=../corekms_tree/ corekms_defconfig`

4. `make -jN`

5. Wait for ten minutes (the time required to compile the whole project on my i5-4570 using j9. Yours may take longer or shorter, depending on you environment.)

6. Profit! The EFISTUB Unified Kernel is `output/images/bzImage`, feel free to rename it to `BOOTX64.EFI` and put it in a disk image if you want. The BIOS ISO is `output/images/rootfs.iso9660` using SysLinux. You may directly boot it with no installation required.

## How to use

The system boots really fast (on my Hyper-V Server it takes less than one second). After booting, it will show the system state screen, indicating the uptime, whether VLMCSD is running, memory information and most importantly, IP addresses (in the `ip-address(8)` format). The system will automatically acquire addresses using DHCP and SLAAC. As long as a new NIC is plugged in, it will setup that adapter as well, with no user interaction.

Press Enter at any time to refresh the status.

Shutdown: Just pull the plug. No data will be corrupted.

## How to develop

The project is splitted into:

1. BuildRoot: In the `buildroot/` directory, type `make nconfig` and edit the configuration. Use `make savedefconfig` to save your changes to `corekms_tree` for submission.

2. Kernel: In the `buildroot/` directory, type `make linux-nconfig` and edit the configuration. Use `make linux-update-config` to save your changes to the `corekms_tree` for submission.

3. BusyBox: In the `buildroot/` directory, type `make busybox-menuconfig` and edit the configuration. Use `make busybox-update-config` to save your changes to the `corekms_tree` for submission.

4. The vlmcsd package: In the `corekms_tree/package/vlmcsd` directory, edit the `Config.in` and `vlmcsd.mk` file.

The `buildroot/` directory must be kept clean. All changes need to be reflected in the `corekms_tree` directory.

> **Note on QEMU**: Make sure to choose a CPU model. For example, `-cpu Skylake-Client-v1`.

## Licenses

WTFPL.

I am not responsible for your usage of this project and vlmcsd. I am not responsible for their legal consequences. I am not the author of vlmcsd.
