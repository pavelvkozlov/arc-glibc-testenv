#!/bin/bash

TAP=${1:-"tap1"}
IP=${2:-"192.168.10.1"}
IMAGE=${3:-"./images/loader"}

PROP=../../propsfiles/hs6x.props
SWAP=../swap_$TAP.raw

# Create and setup tap interface
sudo ip tuntap add $TAP mode tap
sudo ip link set $TAP down
sudo ip addr add $IP/24 dev $TAP
sudo ip link set $TAP up

fallocate -l 1G $SWAP

$ARC_NSIM_PATH/nsimdrv -propsfile $PROP -p nsim_mem-dev=virt-net,tap=$TAP,start=0xf0102000,end=0xf0103fff \
				-prop=nsim_mem-dev=virt-blk,start=0xf0100000,end=0xf0101fff,filename=$SWAP $IMAGE
