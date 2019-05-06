Running Zephyr on QEMU
======================

.. highlight:: bash

Setting up the environment
--------------------------

Please remember to :doc:`get the sources and setup the environment <getting-zephyr>` first.

Compiling an example
--------------------

Create a build directory and run following commands:

.. literalinclude:: scripts/zephyr-qemu.sh
   :start-after: # build example
   :end-before: # /build example

Running an example
------------------

To run an example, simply run:

.. literalinclude:: scripts/zephyr-qemu.sh
   :start-after: # run example
   :end-before: # /run example

You can exit QEMU with :kbd:`C-a` :kbd:`x` key strokes.
