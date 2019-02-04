Running 64- and 32-bit RISC-V Linux on QEMU
===========================================

Prerequisites
-------------

Running Linux on the QEMU RISC-V port requires you to install some prerequisites.
Find instructions for various Linux distributions as well as macOS below:

.. tabs::

   .. tab:: Ubuntu/Debian

      .. note:: This has been tested on Ubuntu 18.04.

      .. code-block:: bash

         sudo apt install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev \
                          gawk build-essential bison flex texinfo gperf libtool patchutils bc \
                          zlib1g-dev libexpat-dev git

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

- `RISC-V newlib and Linux toolchains <https://github.com/riscv/riscv-gnu-toolchain>`_
- `QEMU <https://github.com/qemu/qemu>`_
- `Linux <https://github.com/torvalds/linux>`_
- `BBL (Berkeley Boot Loader) <https://github.com/riscv/riscv-pk>`_
- `Busybear Linux (RISC-V root filesystem image) <https://github.com/michaeljclark/busybear-linux>`_

.. code-block:: bash

    git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
    git clone https://github.com/qemu/qemu
    git clone https://github.com/torvalds/linux
    git clone https://github.com/riscv/riscv-pk
    git clone https://github.com/michaeljclark/busybear-linux

.. note:: You can also use a prebuilt RISC-V GCC toolchain, which can be found on
          `SiFive's website <https://www.sifive.com/products/tools/>`_.

.. note:: If you need to build the root filesystem yourself, you will need to compile
          the Linux cross-compiler yourself, as it isn't provided in the archive
          from SiFive's website.

**For 32-bit**, apply the following patches to their respective repositories: :download:`linux.diff <diffs/linux.diff>`
and :download:`busybear-linux.diff <diffs/busybear-linux.diff>`:

.. code-block:: bash

    cd <repository_name>
    git apply <path_to_diffs>/<repository_name>.diff

Building
--------

If you're using a prebuilt toolchain, skip this step. If not, build the toolchain:


.. jinja::

   .. tabs::

   {% for bits in [64,32] %}

      .. group-tab:: {{bits}}-bit

         .. code-block:: bash

            cd riscv-gnu-toolchain

            # pick an install path, e.g. /opt/riscv{{bits}}
            ./configure --prefix=/opt/riscv{{bits}} {% if bits == 32 %}--with-arch=rv32gc --with-abi=ilp32d{% endif %}
            make newlib -j $(nproc)
            make linux -j $(nproc)

            # export variables
            export PATH="$PATH:/opt/riscv{{bits}}/bin"
            export RISCV="/opt/riscv{{bits}}"

   {% endfor %}

----------

Build QEMU with the RISC-V target:

.. jinja::

   .. tabs::

   {% for bits in [64,32] %}

      .. group-tab:: {{bits}}-bit

         .. code-block:: bash

            cd qemu
            git checkout v3.0.0
            ./configure --target-list=riscv{{bits}}-softmmu
            make -j $(nproc)
            sudo make install

   {% endfor %}

----------

Build Linux for the RISC-V target.
First, checkout to a desired version and copy the default configuration from Busybear:

.. jinja::

   .. tabs::

   {% for bits in [64,32] %}

      .. group-tab:: {{bits}}-bit

         .. code-block:: bash

            cd linux
            git checkout v4.19-rc3
            cp ../busybear-linux/conf/linux.config .config
            make ARCH=riscv CROSS_COMPILE=riscv{{bits}}-unknown-linux-gnu- olddefconfig

   {% endfor %}

Next, enter the kernel configuration, and make sure that the following options are checked:

.. jinja::

   .. tabs::

   {% for bits in [64,32] %}

      .. group-tab:: {{bits}}-bit

         - ``ARCH_RV{{bits}}I``
         - ``CMODEL_MED{% if bits == 64 %}ANY{% else %}LOW{% endif %}``
         - ``CONFIG_SIFIVE_PLIC``

   {% endfor %}

.. jinja::

   .. tabs::

   {% for bits in [64,32] %}

      .. group-tab:: {{bits}}-bit

         .. code-block:: bash

            # enter kernel configuration
            make ARCH=riscv CROSS_COMPILE=riscv{{bits}}-unknown-linux-gnu- nconfig

   {% endfor %}

After accepting changes in the configuration, compile the kernel:

.. jinja::

   .. tabs::

   {% for bits in [64,32] %}

      .. group-tab:: {{bits}}-bit

         .. code-block:: bash

            make ARCH=riscv CROSS_COMPILE=riscv{{bits}}-unknown-linux-gnu- vmlinux -j $(nproc)

   {% endfor %}

----------

Build BBL:

.. jinja::

   .. tabs::

   {% for bits in [64,32] %}

      .. group-tab:: {{bits}}-bit

         .. code-block:: bash

            cd riscv-pk
            mkdir build && cd build
            ../configure --enable-logo --host=riscv{{bits}}-unknown-elf --with-payload=../../linux/vmlinux
            make -j $(nproc)

   {% endfor %}

----------

Build Busybear Linux:

.. code-block:: bash

    cd busybear-linux
    make -j $(nproc)

Running
-------

Go back to your main working directory and run:

.. jinja::

   .. tabs::

   {% for bits in [64,32] %}

      .. group-tab:: {{bits}}-bit

         .. code-block:: bash

            sudo qemu-system-riscv{{bits}} -nographic -machine virt \
                 -kernel riscv-pk/build/bbl -append "root=/dev/vda ro console=ttyS0" \
                 -drive file=busybear-linux/busybear.bin,format=raw,id=hd0 \
                 -device virtio-blk-device,drive=hd0

   {% endfor %}

The default credentials are:

username
    root

password
    busybear

.. only:: html

   A typical run could look as shown in the gif below:

   .. figure:: images/linux64-qemu.gif
      :align: center


