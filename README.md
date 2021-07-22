    # Install libnuma-dev
    yum install numactl-devel  

    cd f-stack
    # Compile DPDK
    cd dpdk/usertools
    ./dpdk-setup.sh # compile with armv8-native-linuxapp-gcc

    # Set hugepage
    echo 4 > /sys/devices/system/node/node0/hugepages/hugepages-524288kB/nr_hugepages
    echo 4 > /sys/devices/system/node/node1/hugepages/hugepages-524288kB/nr_hugepages

    # Using Hugepage with the DPDK
    mkdir /mnt/huge
    mount -t hugetlbfs nodev /mnt/huge


    # Install python for running DPDK python scripts
    sudo apt install python # On ubuntu
    
    # Offload NIC
    modprobe uio
    insmod /data/f-stack/dpdk/armv8-native-linuxapp-gcc/kmod/igb_uio.ko
    python dpdk-devbind.py --status
    ifconfig eth0 down
    python dpdk-devbind.py --bind=igb_uio eth0 # assuming that use 10GE NIC and eth0

    # Install DPDK
    cd ../armv8-native-linuxapp-gcc
    make install

    # Compile F-Stack
    export FF_PATH=/data/f-stack
    export FF_DPDK=/data/f-stack/dpdk/armv8-native-linuxapp-gcc
    cd ../../lib/
    make

    # Install F-STACK
    # libfstack.a will be installed to /usr/local/lib
    # ff_*.h will be installed to /usr/local/include
    # start.sh will be installed to /usr/local/bin/ff_start
    # config.ini will be installed to /etc/f-stack.conf
    make install

#### Nginx

    cd app/nginx-1.16.1
    bash ./configure --prefix=/usr/local/nginx_fstack --with-ff_module
    make
    make install
    cd ../..
    /usr/local/nginx_fstack/sbin/nginx

for more details, see [nginx guide](https://github.com/F-Stack/f-stack/blob/master/doc/F-Stack_Nginx_APP_Guide.md).

2021.01.29
complete easy udp/tcp compatibility function
code road /f-stack/app/LD_PRELOAD
