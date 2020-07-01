Linux
=====

Linux and related tools are - for the most part - already in the upstream repositories of the respective projects.
As noted on the `Debian RISC-V wiki`_ (with some updates):

* binutils: upstreamed (2.28 is the first release with RISC-V support)
* gcc: upstreamed (7.1 is the first release with RISC-V support)
* glibc: upstreamed (2.27 is the first release with RISC-V support)
* linux kernel: upstreamed (the architecture core code went into kernel 4.15; kernel 4.19 contains all drivers necessary for booting a simulated system to userland)
* gdb: upstreamed in master (in the release process)
* qemu: upstreamed (2.12 is the first release with RISC-V support)

Linux-enabled platforms currently described in the Getting Started Guide include:

* :doc:`QEMU <linux-qemu>`
* :doc:`SiFive HiFive Unleashed <linux-hifive-u>`
* :doc:`LiteX SoC with VexRiscv CPU <linux-avalanche>` running on the Future Electronics Avalanche board with a Microsemi PolarFire FPGA or in the Renode simulation framework

Debian, Fedora, and openSUSE ports are also available, for more information see:

* `Debian RISC-V wiki`_
* `Fedora RISC-V wiki`_
* `openSUSE RISC-V wiki`_

.. _Debian RISC-V wiki: https://wiki.debian.org/RISC-V
.. _Fedora RISC-V wiki: https://fedoraproject.org/wiki/Architectures/RISC-V
.. _openSUSE RISC-V wiki: https://en.opensuse.org/openSUSE:RISC-V
