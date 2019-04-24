Running 32-bit RISC-V Linux on LiteX with VexRiscv
==================================================

Prerequisites
-------------

To obtain source code you need to have git installed:
   
.. code-block:: bash

   apt install git

To build RISC-V toolchain you need to have the following packets installed in your system:

.. note:: This has been tested on Ubuntu 18.04.

.. code-block:: bash

   apt install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev \
                   gawk build-essential bison flex texinfo gperf libtool patchutils bc \
                   zlib1g-dev libexpat-dev

To build buildroot:

.. code-block:: bash

   apt install build-essential libncurses5-dev cpio python unzip rsync wget bc

Getting the sources
-------------------

Create a working directory and get all the necessary sources:

.. note:: You can also use a prebuilt RISC-V GCC toolchain, which can be found on
          `SiFive's website <https://www.sifive.com/products/tools/>`_.

.. code-block:: bash
   
   # RISC-V toolchain
   git clone --recursive https://github.com/riscv/riscv-gnu-toolchain

   # kernel 
   git clone -b Machine_Level_Interrupts https://github.com/antmicro/litex-linux-riscv

   # buildroot (rootfs)
   git clone https://git.busybox.net/buildroot

   # Renode (emulation)
   git clone -b Linux_LiteX_VexRiscv https://github.com/renode/renode

Building
--------

Toolchain
+++++++++

Skip this step if you use pre-built toolchain. Otherwise execute in the working directory:

.. code-block:: bash

   cd riscv-gnu-toolchain

   ./configure --prefix=/opt/riscv-rv32gc-ilp32d --with-arch=rv32gc --with-abi=ilp32d
   make newlib -j $(nproc) # this generates -unknown- version
   make linux -j $(nproc)  # this generates -linux- version

   # export variables
   export PATH="$PATH:/opt/riscv-rv32gc-ilp32d/bin"

Kernel
++++++

Step into the Linux kernel directory from the working directory and setup the environment:

.. code-block:: bash
   
   cd litex-linux-vexriscv
   export CROSS_COMPILE=riscv32-unknown-linux-gnu-
   export ARCH=riscv

Use the configuration available in the kernel's root directory:

.. code-block:: bash

   cp litex_default_configuration .config

.. note::

   If you want to modify the configuration, execute: `make menuconfig`

Build it and generate binary:

.. code-block:: bash

   make -j$(nproc)
   riscv32-unknown-linux-gnu-objcopy -O binary vmlinux vmlinux.bin

as a result you get `vmlinux` and `vmlinux.bin`.


Buildroot
+++++++++

Use buildroot tool to generate rootfs. Enter the buildroot directory and run the configuration script:

.. code-block:: bash

   cd builrdoot
   make menuconfig

Make sure that the following options are selected:

.. code-block:: text

   Target options --->
      Target Architecture: RISCV
      Target Architecture Variant: Custom architecture
      (Disable M, F, C)
      Target Architecture Size: 32-bit

   Toolchain --->
      Kernel Headers: Linux 4.19.x kernel headers

   Filesystem images --->
      ext2/3/4 root filesystem: Y
         ext2/3/4 variant: ext2 (rev1)
         exact size: 48MB
         Compression mode: gzip
      tar the root filesystem: Y
         Compression mode: no compression

   make 

.. note:: 
   
   Optionally you can select additional packages. Check if output image size does not exceed the configured limit (48M) as otherwise it won't fit into a ramdisk.

Renode
++++++

.. note::

   Support for Linux-enabled LiteX with VexRiscv is not available in pre-built packages,
   refer to `the documentation <https://renode.readthedocs.io/en/latest/advanced/building_from_sources.html>`_ for details on how to install Renode from sources. 

Building Renode is simple, just enter its directory and run a build script:

.. code-block:: bash

   cd renode
   ./build.sh

Running
-------

Preparing the platform
++++++++++++++++++++++

.. tabs::

   .. group-tab:: Renode

      Start Renode and create an instance of emulated LiteX+VexRiscv board:

      .. code-block:: text

         mach create "LiteX_VexRiscv"
         machine LoadPlatformDescription @platforms/cpus/litex_vexriscv.repl

Loading binaries
++++++++++++++++

.. tabs::

   .. group-tab:: Renode

      To load the binaries onto the emulated platform, just do:

      .. code-block:: text

         sysbus LoadELF @vmlinux True
         sysbus LoadFdt @rv32.dtb 0x41000000
         sysbus LoadBinary @rootfs.ext2 0x42000000

         # kernel emulates A instructions in Illegal Instruction trap
         # do not report errors about atomic instructions in log 
         sysbus.cpu SilenceUnsupportedInstructionSet A

Attaching to UART
+++++++++++++++++

.. tabs::

   .. group-tab:: Renode

      Open UART window:

      .. code-block:: text

         showAnalyzer sysbus.uart

Running Linux
+++++++++++++

.. tabs::

   .. group-tab:: Renode

      Start the emulation:

      .. code-block:: text

         start

You should see an output in *UART* window:

.. code-block:: text

   [    0.000000] Linux version 4.19.0-rc4-gb0c584afa (houen@bakura) (gcc version 7.2.0 (GCC)) #135 Tue May 7 13:16:23 CEST 2019
   [    0.000000] earlycon: litex_uart_a0 at MMIO 0x00000000e0001800 (options '115200')
   [    0.000000] bootconsole [litex_uart_a0] enabled
   [    0.000000] Initial ramdisk at: 0x(ptrval) (50331648 bytes)
   MEMBLOCK configuration:
   memory size = 0x0000000010000000 reserved size = 0x00000000036bfb6a
   [    0.000000]  memory.cnt  = 0x1
   [    0.000000]  memory[0x0] [0x00000000c0000000-0x00000000cfffffff], 0x0000000010000000 bytes flags: 0x0
   [    0.000000]  reserved.cnt  = 0x3
   [    0.000000]  reserved[0x0] [0x00000000c0000000-0x00000000c06bf283], 0x00000000006bf284 bytes flags: 0x0
   [    0.000000]  reserved[0x1] [0x00000000c1000000-0x00000000c10008e5], 0x00000000000008e6 bytes flags: 0x0
   [    0.000000]  reserved[0x2] [0x00000000c2000000-0x00000000c4ffffff], 0x0000000003000000 bytes flags: 0x0
   [    0.000000] Zone ranges:
   [    0.000000]   Normal   [mem 0x00000000c0000000-0x00000000cfffffff]
   [    0.000000] Movable zone start for each node
   [    0.000000] Early memory node ranges
   [    0.000000]   node   0: [mem 0x00000000c0000000-0x00000000cfffffff]
   [    0.000000] Initmem setup node 0 [mem 0x00000000c0000000-0x00000000cfffffff]
   [    0.000000] software IO TLB: mapped [mem 0xcfdbe000-0xcfdfe000] (0MB)
   [    0.000000] elf_hwcap is 0x1100
   [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 65024
   [    0.000000] Kernel command line: earlycon mem=256M@0x40000000 rootwait console=ttyLX0,115200 root=/dev/ram0 init=/sbin/init swiotlb=32
   [    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
   [    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
   [    0.000000] Sorting __ex_table...
   [    0.000000] Memory: 203500K/262144K available (4857K kernel code, 426K rwdata, 793K rodata, 260K init, 565K bss, 58644K reserved, 0K cma-reserved)
   [    0.000000] NR_IRQS: 0, nr_irqs: 0, preallocated irqs: 0
   [    0.000000] clocksource: riscv_clocksource: mask: 0xffffffffffffffff max_cycles: 0x114c1bade8, max_idle_ns: 440795203839 ns
   [    0.000000] Console: colour dummy device 80x25
   [    0.000000] console on ttyLX0 not present
   [    0.000000] Calibrating delay loop (skipped), value calculated using timer frequency.. 150.00 BogoMIPS (lpj=750000)
   [    0.000000] pid_max: default: 32768 minimum: 301
   [    0.000000] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
   [    0.000000] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
   [    0.030000] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
   [    0.030000] futex hash table entries: 256 (order: 0, 7168 bytes)
   [    0.030000] random: get_random_u32 called from bucket_table_alloc+0xa0/0x20c with crng_init=0
   [    0.030000] NET: Registered protocol family 16
   [    0.090000] clocksource: Switched to clocksource riscv_clocksource
   [    0.440000] NET: Registered protocol family 2
   [    0.450000] tcp_listen_portaddr_hash hash table entries: 256 (order: 0, 6144 bytes)
   [    0.450000] TCP established hash table entries: 2048 (order: 1, 8192 bytes)
   [    0.450000] TCP bind hash table entries: 2048 (order: 3, 40960 bytes)
   [    0.450000] TCP: Hash tables configured (established 2048 bind 2048)
   [    0.450000] UDP hash table entries: 256 (order: 1, 12288 bytes)
   [    0.450000] UDP-Lite hash table entries: 256 (order: 1, 12288 bytes)
   [    0.450000] NET: Registered protocol family 1
   [    0.460000] RPC: Registered named UNIX socket transport module.
   [    0.460000] RPC: Registered udp transport module.
   [    0.460000] RPC: Registered tcp transport module.
   [    0.460000] RPC: Registered tcp NFSv4.1 backchannel transport module.
   [    0.460000] Trying to unpack rootfs image as initramfs...
   [    0.470000] rootfs image is not initramfs (junk in compressed archive); looks like an initrd
   [    1.700000] workingset: timestamp_bits=30 max_order=16 bucket_order=0
   [    1.710000] NFS: Registering the id_resolver key type
   [    1.710000] Key type id_resolver registered
   [    1.710000] Key type id_legacy registered
   [    1.710000] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
   [    1.710000] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
   [    1.740000] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
   [    1.740000] io scheduler noop registered
   [    1.740000] io scheduler deadline registered
   [    1.740000] io scheduler cfq registered (default)
   [    1.740000] io scheduler mq-deadline registered
   [    1.740000] io scheduler kyber registered
   [    2.130000] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
   [    2.150000] litex console: port=(ptrval); port->mapbase=e0001800
   [    2.150000] e0001800.serial0: ttyLX0 at MMIO 0xe0001800 (irq = 2, base_baud = 0) is a litex_uart
   [    2.150000] console [ttyLX0] enabled
   [    2.150000] console [ttyLX0] enabled
   [    2.150000] bootconsole [litex_uart_a0] disabled
   [    2.150000] bootconsole [litex_uart_a0] disabled
   [    2.230000] brd: module loaded
   [    2.230000] libphy: Fixed MDIO Bus: probed
   [    2.240000] liteeth e0009800.mac eth0: irq 1, mapped at (ptrval)
   [    2.250000] NET: Registered protocol family 10
   [    2.260000] Segment Routing with IPv6
   [    2.270000] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
   [    2.280000] NET: Registered protocol family 17
   [    2.280000] Key type dns_resolver registered
   [    2.290000] RAMDISK: ext2 filesystem found at block 0
   [    2.290000] RAMDISK: Loading 49152KiB [1 disk] into ram disk... -
   [    3.190000] \
   [    4.010000] |
   [    5.490000] /
   [    7.480000] -
   [    9.450000] \
   [   11.520000] |
   [   13.660000] done.
   [   17.000000] EXT4-fs (ram0): mounted filesystem without journal. Opts: (null)
   [   17.000000] VFS: Mounted root (ext4 filesystem) readonly on device 1:0.
   [   17.010000] Freeing unused kernel memory: 260K
   [   17.010000] This architecture does not have kernel memory protection.
   [   17.010000] Run /sbin/init as init process
   [   17.270000] EXT4-fs (ram0): re-mounted. Opts: block_validity,delalloc,barrier,user_xattr
   Starting syslogd: OK
   Starting klogd: OK
   Initializing random number generator... [   18.760000] random: dd: uninitialized urandom read (512 bytes read)
   done.
   Starting network: OK
   Welcome to Buildroot
   buildroot login: root
   # python
   Python 2.7.15 (default, Apr  5 2019, 14:11:28)
   [GCC 7.4.0] on linux2
   Type "help", "copyright", "credits" or "license" for more information.
   >>> 21 * 2
   42
   >>>

