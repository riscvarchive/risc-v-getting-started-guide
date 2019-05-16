#!/bin/bash

set -e

# get prerequisites
sudo apt install autoconf automake autotools-dev bc bison build-essential curl cpio flex \
                 gawk gdisk git gperf libgmp-dev libmpc-dev libmpfr-dev libncurses-dev \
                 libssl-dev libtool patchutils python rsync screen texinfo unzip zlib1g-dev
# /get prerequisites

# clone
git clone https://github.com/buildroot/buildroot
cd buildroot
git checkout 653bf9383721a2e2d3313ae08a3019b864326
git am ../../files/0001-Add-Litex-VexRiscv-support.patch
# /clone

# build
mkdir ~/vexriscv-bins
make litex_vexriscv_defconfig
make -j`nproc`
cp output/images/Image output/images/rootfs.cpio ~/vexriscv-bins
# /build

# get bitstream
wget https://github.com/riscv/risc-v-getting-started-guide/releases/download/tip/bitstream-litex-vexriscv-avalanche-linux.job
# /get bitstream

# get prebuilt binaries
cd ~/vexriscv-bins
wget https://github.com/riscv/risc-v-getting-started-guide/releases/download/tip/devicetree-litex-vexriscv-avalanche-linux.dtb
wget https://github.com/riscv/risc-v-getting-started-guide/releases/download/tip/emulator-litex-vexriscv-avalanche-linux.bin
# /get prebuilt binaries

# flash
# get the litex_term tool
wget https://raw.githubusercontent.com/enjoy-digital/litex/190ff89aaa120cc983ccaeb1077ba1d23f00e37c/litex/tools/litex_term.py
wget https://raw.githubusercontent.com/antmicro/risc-v-getting-started-guide/master/source/files/images-litex-vexriscv-avalanche-linux.json
chmod +x litex_term.py
# assuming the board serial has been registered as ttyUSB0
./litex_term.py --images images-litex.json /dev/ttyUSB0
# /flash

