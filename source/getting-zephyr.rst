Getting Zephyr
==============

.. highlight:: bash

Note that a complete `Getting Started Guide <https://docs.zephyrproject.org/latest/getting_started/getting_started.html>`_ including installation instructions for different OSs is available in the Zephyr Project documentation.

Here, we will focus on a Ubuntu Linux based environment for simplicity and clarity.

First, you will need to install the following prerequisities:

.. literalinclude:: scripts/getting-zephyr.sh
   :start-after: # install prerequisites
   :end-before: # /install prerequisites

Then, download the Zephyr source code, install additional dependencies and export variables:

.. literalinclude:: scripts/getting-zephyr.sh
   :start-after: # download Zephyr
   :end-before: # /download Zephyr

Download and install Zephyr SDK (note that in the last line you need to insert the value of ``<zephyr_sdk_install_dir>`` that you selected during installation):

.. literalinclude:: scripts/getting-zephyr.sh
   :start-after: # install Zephyr SDK
   :end-before: # /install Zephyr SDK

