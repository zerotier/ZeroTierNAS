Synology DiskStation NAS + ZeroTier
======

The hacky way: 

### Installation

Build ZeroTierOne in the usual way, place the binary in the `hacky` directory.

```
./install
```

This will copy the traditional ZeroTier files to their normal locations. A script will be added to handle the loading of the TUN/TAP kernel module on boot. This will be located at `/usr/local/etc/rc.d/zerotierone.sh`.

After startup it may be necessary to leave and re-join your networks for it to be reachable.

***

Tested on:

[DS216+II (Intel Celeron N3060)](https://www.synology.com/en-us/products/DS216+II)