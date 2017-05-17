#!/bin/sh

install_path=$1

ln -s $install_path/bin/zerotier-one /usr/sbin/zerotier-one
ln -s $install_path/bin/zerotier-one /usr/sbin/zerotier-cli
ln -s $install_path/bin/zerotier-one /usr/bin/zerotier-one
ln -s $install_path/bin/zerotier-one /usr/bin/zerotier-cli

ln -s $install_path/ /var/lib/zerotier-one

ln -s $install_path/webpage /var/www/zerotier
ln -s $install_path/cgi/* /var/www/cgi-bin/