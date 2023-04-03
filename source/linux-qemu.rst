Running 64- and 32-bit RISC-V Linux on QEMU
===========================================

This is a "hello world" example of booting Linux on RISC-V QEMU. This guide covers some basic steps
to get Linux running on RISC-V. It is recomended that if you are interested in a specific distrubution
you follow their steps. For example if you are interested in running Debian, they have instructions
on their wiki https://wiki.debian.org/RISC-V. Most distrobutions (Debian, Fedora, OpenEmbedded, buildroot,
OpenSUSE, FreeBSD and others) support RISC-V.

Prerequisites
-------------

Running Linux on QEMU RISC-V requires you to install some prerequisites.
Find instructions for various Linux distributions as well as macOS below:

.. tabs::

   .. tab:: Ubuntu/Debian

      .. note:: This has been tested on Ubuntu 18.04.

      .. code-block:: bash

         sudo apt install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev \
                          gawk build-essential bison flex texinfo gperf libtool patchutils bc \
                          zlib1g-dev libexpat-dev git python3

   .. tab:: Fedora/CentOS/RHEL OS

      .. code-block:: bash

         sudo yum install autoconf automake libmpc-devel mpfr-devel gmp-devel gawk bison flex \
                          texinfo patchutils gcc gcc-c++ zlib-devel expat-devel git

   .. tab:: macOS

      .. code-block:: bash

         brew install gawk gnu-sed gmp mpfr libmpc isl zlib expat

Getting the sources
-------------------

First, create a working directory, where we'll download and build all the sources.

.. jinja::

   .. tabs::

   {% for bits in [64,32] %}

      .. group-tab:: {{bits}}-bit

         .. code-block:: bash

            mkdir riscv{{bits}}-linux
            cd riscv{{bits}}-linux

   {% endfor %}

Then download all the required sources, which are:

- `QEMU <https://github.com/qemu/qemu>`_
- `Linux <https://github.com/torvalds/linux>`_
- `Busybox <https://git.busybox.net/busybox>`_

.. code-block:: bash

    git clone https://github.com/qemu/qemu
    git clone https://github.com/torvalds/linux
    git clone https://git.busybox.net/busybox

You will also need to install a RISC-V toolchain. It is recomendded to install a toolchain from your distro.
This can be done by using your distro's installed (apt, dnf, pacman or something similar) and searching for
riscv64 and installing gcc. If that doesn't work you can use a prebuilt toolchain from: https://toolchains.bootlin.com.

----------

Build QEMU with the RISC-V target:

.. jinja::

   .. tabs::

   {% for bits in [64,32] %}

      .. group-tab:: {{bits}}-bit

         .. code-block:: bash

            cd qemu
            git checkout v5.0.0
            ./configure --target-list=riscv{{bits}}-softmmu
            make -j $(nproc)
            sudo make install

   {% endfor %}

----------

Build Linux for the RISC-V target.
First, checkout to a desired version:

.. jinja::

   .. tabs::

   {% for bits in [64,32] %}

      .. group-tab:: {{bits}}-bit

         .. code-block:: bash

            cd linux
            git checkout v5.4
            make ARCH=riscv CROSS_COMPILE=riscv{{bits}}-unknown-linux-gnu- defconfig

   {% endfor %}

Then compile the kernel:

.. jinja::

   .. tabs::

   {% for bits in [64,32] %}

      .. group-tab:: {{bits}}-bit

         .. code-block:: bash

            make ARCH=riscv CROSS_COMPILE=riscv{{bits}}-unknown-linux-gnu- -j $(nproc)

   {% endfor %}

----------

Build Busybox:

.. code-block:: bash

    cd busybox
    CROSS_COMPILE=riscv{{bits}}-unknown-linux-gnu- make defconfig
    CROSS_COMPILE=riscv{{bits}}-unknown-linux-gnu- make -j $(nproc)

Running
-------

Go back to your main working directory and run:

.. jinja::

   .. tabs::

   {% for bits in [64,32] %}

      .. group-tab:: {{bits}}-bit

         .. code-block:: bash

            sudo qemu-system-riscv{{bits}} -nographic -machine virt \
                 -kernel linux/arch/riscv/boot/Image -append "root=/dev/vda ro console=ttyS0" \
                 -drive file=busybox,format=raw,id=hd0 \
                 -device virtio-blk-device,drive=hd0

   {% endfor %}
