Synology DiskStation NAS + ZeroTier
======

The hacky way: 

- ZeroTier requires a TUN/TAP device, load kernel module:

```
find /lib/modules/ -iname 'tun.ko'
```

```
insmod /lib/modules/tun.ko
```