#!/bin/sh
# startup script

# Load TUN/TAP kernel module
sudo insmod /lib/modules/tun.ko

# Start ZeroTier service
sudo ./var/lib/zerotier-one/start-stop-status.sh start