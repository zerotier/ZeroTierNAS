#!/bin/sh

APKG_PKG_DIR=/usr/local/AppCentral/zerotier

case "$APKG_PKG_STATUS" in

	install)
		modprobe tun
		ln -s $APKG_PKG_DIR/zerotier-one /usr/sbin/zerotier-cli
		ln -s $APKG_PKG_DIR/zerotier-one /usr/bin/zerotier-cli
		;;
	upgrade)
		# post upgrade script here (restore data)
		# cp -af $APKG_TEMP_DIR/* $APKG_PKG_DIR/etc/.
		;;
	*)
		;;

esac

exit 0
