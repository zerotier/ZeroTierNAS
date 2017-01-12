Synology DiskStation NAS + ZeroTier
======

The hacky way: 

- 
- ZeroTier requires a TUN/TAP device, load kernel module:

```
find /lib/modules/ -iname 'tun.ko'
```

```
insmod /lib/modules/tun.ko
```


***

Tested on:

[DS216+II (Intel Celeron N3060)](https://www.synology.com/en-us/products/DS216+II)