#!/bin/sh

. /etc/script/lib/command.sh

APKG_PKG_DIR=/usr/local/AppCentral/zerotier
PID_FILE=/var/run/zerotier-one.pid

case $1 in

	start)
		modprobe tun
		# start script here
		$APKG_PKG_DIR/bin/zerotier-one -d
		echo $! > $PID_FILE
		;;

	stop)
		# stop script here
		kill -9 `cat $PID_FILE` 2> /dev/null
		rm -rf $PID_FILE
		;;

	*)
		echo "usage: $0 {start|stop}"
		exit 1
		;;
esac

exit 0
