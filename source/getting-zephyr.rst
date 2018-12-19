Getting Zephyr
==============

Note that a complete `Getting Started Guide <https://docs.zephyrproject.org/latest/getting_started/getting_started.html>`_including installation instructions for different OSs is available in the Zephyr Project documentation.

Here, we will focus on a Ubuntu Linux based environment for simplicity and clarity.

First, you will need to install the following prerequisities:

.. code-block:: bash

   sudo apt-get install --no-install-recommends git cmake ninja-build gperf \
     ccache dfu-util device-tree-compiler wget \
     python3-pip python3-setuptools python3-wheel xz-utils file make gcc \
     gcc-multilib

Then, download the Zephyr source code, install additional dependencies and export variables:

.. code-block:: bash

    git clone https://github.com/zephyrproject-rtos/zephyr
    cd zephyr
    pip3 install --user -r scripts/requirements.txt
    export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
    . ./zephyr-env.sh

Download and install Zephyr SDK (note that in the last line you need to insert the value of ``<zephyr_sdk_install_dir>`` that you selected during installation):

.. code-block:: bash

    wget https://github.com/zephyrproject-rtos/meta-zephyr-sdk/releases/download/0.9.5/zephyr-sdk-0.9.5-setup.run
    sh zephyr-sdk-0.9.5-setup.run
    export ZEPHYR_SDK_INSTALL_DIR=<zephyr_sdk_install_dir>

