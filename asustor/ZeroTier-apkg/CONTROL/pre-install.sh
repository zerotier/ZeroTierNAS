#!/bin/sh

APKG_PKG_DIR=/usr/local/AppCentral/zerotier

case "$APKG_PKG_STATUS" in

	install)
		# pre install script here
		;;
	upgrade)
		# pre upgrade script here (backup data)
		# cp -af $APKG_PKG_DIR/etc/* $APKG_TEMP_DIR/.
		;;
	*)
		;;

esac

exit 0
