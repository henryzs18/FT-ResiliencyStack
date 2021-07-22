#!/bin/sh
export RTE_SDK=$(pwd)/dpdk
export RTE_TARGET=arm64-armv8a-linuxapp-gcc
cd dpdk/
make config T=arm64-armv8a-linuxapp-gcc
make
cd ..
export FF_PATH=../f-stack
export FF_DPDK=$RTE_SDK/$RTE_TARGET
echo 4 > /sys/devices/system/node/node0/hugepages/hugepages-524288kB/nr_hugepages
echo 4 > /sys/devices/system/node/node1/hugepages/hugepages-524288kB/nr_hugepages
modprobe uio
rmmod igb_uio
insmod $RTE_SDK/$RTE_TARGET/kmod/igb_uio.ko
#ifconfig enp4s0f0 down
#ifconfig enp4s0f1 down
#$RTE_SDK/usertools/dpdk-devbind.py --bind=igb_uio 0000:04:00.0
#$RTE_SDK/usertools/dpdk-devbind.py --bind=igb_uio 0000:04:00.1
