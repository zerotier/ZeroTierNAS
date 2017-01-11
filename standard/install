#! /bin/sh

# traditional install

mkdir -p /usr/sbin
rm -f /usr/sbin/zerotier-one
cp -f zerotier-one /usr/sbin/zerotier-one

rm -f /usr/sbin/zerotier-cli
rm -f /usr/sbin/zerotier-idtool
ln -s zerotier-one /usr/sbin/zerotier-cli
ln -s zerotier-one /usr/sbin/zerotier-idtool

mkdir -p /var/lib/zerotier-one
rm -f /var/lib/zerotier-one/zerotier-one
rm -f /var/lib/zerotier-one/zerotier-cli
rm -f /var/lib/zerotier-one/zerotier-idtool
ln -s ../../../usr/sbin/zerotier-one /var/lib/zerotier-one/zerotier-one
ln -s ../../../usr/sbin/zerotier-one /var/lib/zerotier-one/zerotier-cli
ln -s ../../../usr/sbin/zerotier-one /var/lib/zerotier-one/zerotier-idtool

# integration with DSM 6.0

# copy into local directory (volume1/@tmp)