Getting Zephyr
==============

First, install the following prerequisities:

.. code-block:: bash

    sudo apt install git cmake ninja-build gperf ccache doxygen dfu-util device-tree-compiler \
                     python3-ply python3-pip python3-setuptools python3-wheel xz-utils file \
                     make gcc-multilib autoconf automake libtool librsvg2-bin texlive-latex-base \
                     texlive-latex-extra latexmk texlive-fonts-recommended

Then, download the Zephyr source code, install additional dependencies and export variables:

.. code-block:: bash

    git clone https://github.com/zephyrproject-rtos/zephyr
    cd <path_where_zephyr_is_cloned>
    pip3 install --user -r scripts/requirements.txt
    export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
    . ./zephyr-env.sh

Download and install Zephyr SDK:

.. code-block:: bash

    wget https://github.com/zephyrproject-rtos/meta-zephyr-sdk/releases/download/0.9.3/zephyr-sdk-0.9.3-setup.run
    sh zephyr-sdk-0.9.3-setup.run
    export ZEPHYR_SDK_INSTALL_DIR=<zephyr_sdk_install_dir>

.. note:: You can find more detailed information related to the RTOS in `Zephyr's documentation <https://docs.zephyrproject.org/latest/index.html>`_.

