QNAP
======

[![irc](https://img.shields.io/badge/IRC-%23zerotier%20on%20freenode-orange.svg)](https://webchat.freenode.net/?channels=zerotier)

Pre-Built Binaries/Packages Here: [zerotier.com/download.shtml](https://zerotier.com/download.shtml?pk_campaign=github_ZeroTierNAS)

***

#### Build Instructions:

```
ln -s /bin/sh /bin/bash
cd `getcfg QDK Install_Path -f /etc/config/qpkg.conf
qbuild --create-env ZeroTier
cd ZeroTier/
```

Set config options (optional):

`vi qpkg.cfg`

Build:

`qbuild`

The finished product is located in:

`build/`