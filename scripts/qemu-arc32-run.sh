#!/bin/sh

TAP=${1:-"tap1"}
IP=${2:-"192.168.10.1"}
IMAGE=${3:-"./images/vmlinux"}

SWAP=../swap_$TAP.raw

# Create and setup tap interface
sudo ip tuntap add $TAP mode tap
sudo ip link set $TAP down
sudo ip addr add $IP/24 dev $TAP
sudo ip link set $TAP up

fallocate -l 1G $SWAP

$ARC_QEMU_PATH/qemu-system-arc -cpu hs5x -M virt -m 1024 -display none -kernel $IMAGE \
                -netdev tap,id=net0,ifname=$TAP,script=no,downscript=no \
                -device virtio-net-device,netdev=net0 \
                -drive file=$SWAP,format=raw,id=hd0 -device virtio-blk-device,drive=hd0 \
                --global cpu.freq_hz=30000000 -nographic
