#!/bin/bash

# This script exists as a convenient way to install the TUN module if for some reason it wasn't loaded during install

# load TUN kernel module
SERVICE="zerotier"
ZEROTIER_MODULE="tun.ko"
BIN_SYNOMODULETOOL="/usr/syno/bin/synomoduletool"

# Make device if not present (not devfs)
if ( [ ! -c /dev/net/tun ] ) then
		# Make /dev/net directory if needed
		if ( [ ! -d /dev/net ] ) then
    		mkdir -m 755 /dev/net
		fi
		mknod /dev/net/tun c 10 200
fi

# Load TUN kernel module
if [ -x ${BIN_SYNOMODULETOOL} ]; then
	$BIN_SYNOMODULETOOL --insmod $SERVICE ${ZEROTIER_MODULE}
else
	/sbin/insmod /lib/modules/${ZEROTIER_MODULE}
fi

exit 0
