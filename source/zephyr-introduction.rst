Zephyr
======

The `Zephyr OS <https://www.zephyrproject.org/>`_ is a popular security-oriented RTOS with a small-footprint kernel designed for use on resource-constrained and embedded systems.

It is fully open source, highly configurable and modular, making it perfect for developers building everything from simple embedded environmental sensors and LED wearables to sophisticated embedded controllers, smart watches, and IoT wireless applications.

The Zephyr OS is managed by the vendor neutral Zephyr Project which is part of the Linux Foundation.

Zephyr-enabled platforms currently described in the Getting Started Guide include:

* :doc:`SiFive HiFive1 <zephyr-hifive1>`
* :doc:`LiteX SoC with VexRiscv CPU <zephyr-litex>` running on the Future Electronics Avalanche board with a Microsemi PolarFire FPGA or in the `Renode <https://renode.io>`_ simulation framework

.. sidebar:: And the winner is...

   The VexRiscv CPU, which is also capable of running Linux in FPGA, is the winner of the first edition of the RISC-V Soft CPU contest due to its very effective implementation in FPGA using the author's own Scala-based HDL generator language, SpinalHDL. The LiteX soft SoC, developed in MiGen/Python that VexRiscv can be - and often is - combined with scales from simple designs with UART or SPI, I2C to complex setups with Ethernet, USB, PCIe, DDR controllers etc. Those two projects illustrate the active, software-driven community around RISC-V.

There is also a generic :doc:`QEMU simulation target <zephyr-qemu>` supporting RISC-V.

For a full list of supported boards and details, see `the Zephyr documentation <https://docs.zephyrproject.org/latest/boards/riscv32/index.html>`_.

Why Zephyr?
-----------

Zephyr is a generic, open source, cross-platform and vendor-independent RTOS, with a well-constructed governance structure and extensive and active community.
Just like RISC-V, it has security and flexibility in mind, and comes with 'batteries included', enabling a wide array of applications thanks to a number of different configurations available.

Zephyr follows standard coding guidelines, best practices - shared with the wider Linux ecosystem and based on lessons learned from over 25 years of OS development - and a community approach for which it is especially praised.
