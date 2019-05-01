#!/bin/sh

. /etc/script/lib/command.sh

APKG_PKG_DIR=/usr/local/AppCentral/zerotier
PID_FILE=/var/run/zerotier-one.pid

#JAVA_CMD=/usr/local/bin/java

case $1 in

	start)
		modprobe tun
		# start script here
		$APKG_PKG_DIR/zerotier-one $APKG_PKG_DIR -d
		#cd $APKG_PKG_DIR/lib/
		#$JAVA_CMD WebServer $APKG_PKG_DIR/webapp/ 7777 > /dev/null &
		echo $! > $PID_FILE
		;;

	stop)
		#killall zerotier-one
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
