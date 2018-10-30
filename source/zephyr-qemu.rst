Running Zephyr on QEMU
======================

Setting up the environment
--------------------------

Please remember to :doc:`get the sources and setup the environment <getting-zephyr>` first.

Compiling an example
--------------------

Create a build directory and run following commands:

.. code-block:: bash

    mkdir build-example
    cmake -DBOARD=qemu_riscv32 $ZEPHYR_BASE/samples/hello_world
    make -j $(nproc)

Running an example
------------------

To run an example, simply run:

.. code-block:: bash

    make run

You can exit QEMU with ``C-a x`` key strokes.
