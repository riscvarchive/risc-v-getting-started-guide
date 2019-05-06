#!/bin/bash

set -e

# build example
mkdir build-example
cd build-example
cmake -DBOARD=qemu_riscv32 $ZEPHYR_BASE/samples/hello_world
make -j $(nproc)
# /build example

# run example
make run
# /run example
