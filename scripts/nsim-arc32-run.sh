#!/bin/bash

IMAGE=./images/vmlinux
PROP=../../propsfiles/hs5x.props

TAP=${1:-"tap1"}
IP=${2:-"192.168.10.1"}

# Create and setup tap interface
sudo ip tuntap add $TAP mode tap
sudo ip link set $TAP down
sudo ip addr add $IP/24 dev $TAP
sudo ip link set $TAP up

$ARC_NSIM_PATH/nsimdrv -propsfile $PROP -p nsim_mem-dev=virt-net,tap=$TAP,start=0xf0102000,end=0xf0103fff $IMAGE
