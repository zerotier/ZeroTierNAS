#!/bin/sh
# ZeroTierOne startup script

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

# Load TUN/TAP kernel module
if [ -x ${BIN_SYNOMODULETOOL} ]; then
	$BIN_SYNOMODULETOOL --insmod $SERVICE ${ZEROTIER_MODULE}
else
	/sbin/insmod /lib/modules/${ZEROTIER_MODULE}
fi

# Start ZeroTier service
sudo ./var/lib/zerotier-one/start-stop-status.sh start