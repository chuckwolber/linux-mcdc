#!/bin/bash

cd $MCDC_HOME/linux
make LLVM=1 defconfig

./scripts/config -e CONFIG_9P_FS_POSIX_ACL
./scripts/config -e CONFIG_9P_FS
./scripts/config -e CONFIG_NET_9P_VIRTIO
./scripts/config -e CONFIG_NET_9P
./scripts/config -e CONFIG_PCI
./scripts/config -e CONFIG_VIRTIO_PCI
./scripts/config -e CONFIG_OVERLAY_FS
./scripts/config -e CONFIG_DEBUG_FS
./scripts/config -e CONFIG_CONFIGFS_FS
./scripts/config -e CONFIG_MAGIC_SYSRQ
make LLVM=1 olddefconfig

./scripts/config -e CONFIG_KUNIT
./scripts/config -e CONFIG_KUNIT_ALL_TESTS
make LLVM=1 olddefconfig

./scripts/config -e CONFIG_LLVM_COV_KERNEL
./scripts/config -e CONFIG_LLVM_COV_KERNEL_MCDC
./scripts/config --set-val LLVM_COV_KERNEL_MCDC_MAX_CONDITIONS 44
make LLVM=1 olddefconfig

cat << EOF
Building the kernel with output suppressed. The log tail will be displayed once
the process finishes. See the full log in the next step.
EOF
/usr/bin/time -v -o /tmp/time.log make LLVM=1 -j$(nproc) >& /tmp/make.log
tail -n 200 /tmp/make.log