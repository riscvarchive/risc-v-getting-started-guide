Getting Zephyr
==============

.. highlight:: bash

Note that a complete `Getting Started Guide <https://docs.zephyrproject.org/latest/getting_started/getting_started.html>`_ including installation instructions for different OSs is available in the Zephyr Project documentation.

Here, we will focus on a Ubuntu Linux based environment for simplicity and clarity.

First, you will need to install the following prerequisities:

.. literalinclude:: scripts/getting-zephyr.sh
   :start-after: # install prerequisites
   :end-before: # /install prerequisites

Then, download the Zephyr source code and install additional dependencies:

.. literalinclude:: scripts/getting-zephyr.sh
   :start-after: # download Zephyr
   :end-before: # /download Zephyr

Set up the environment (do this always for a shell where you will be compiling/running Zephyr):

.. literalinclude:: scripts/getting-zephyr.sh
   :start-after: # set up env
   :end-before: # /set up env

Download and install Zephyr SDK (note that you can use a different directory for the SDK installation by changing the shell variable set in the snippet above; the value used here is just a sane default):

.. literalinclude:: scripts/getting-zephyr.sh
   :start-after: # install Zephyr SDK
   :end-before: # /install Zephyr SDK

