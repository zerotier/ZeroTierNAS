ZeroTier for QNAP
======

[![irc](https://img.shields.io/badge/IRC-%23zerotier%20on%20freenode-orange.svg)](https://webchat.freenode.net/?channels=zerotier)

**Download pre-built packages here:** [zerotier.com/download.shtml](https://zerotier.com/download.shtml?pk_campaign=github_ZeroTierNAS)

***

#### Tested on:

 - [TS-251+](https://www.qnap.com/en-us/product/model.php?II=195)

#### Package Build Instructions:

 - Clone this repo and [ZeroTierOne](https://github.com/zerotier/ZeroTierOne/tree/master)
 
 - In [ZeroTierOne](https://github.com/zerotier/ZeroTierOne/tree/master) repo, `make one ZT_QNAP=1`
 
 - Copy resultant `zerotier-one` into appropriate platform folder `QNAP/x86`, `QNAP/x86_64`, etc.
 
 - `tar -cvf qnap.tar`

 - On the QNAP system, install the [QDK](http://download.qnap.com/Storage/Utility/QDK_2.2.4.zip)
 
 - Go to dev directory defined by: `getcfg QDK Install_Path -f /etc/config/qpkg.conf` 

 - Copy previously mentioned `qnap.tar` to your QNAP system and untar it in the dev directory under `ZeroTier`

 - On QNAP System, enter `ZeroTier` directory and run `qbuild`

 - Tar up the result and send it back to your dev system.

 #### For developers:

 Toolchains:

  - [x86](https://sourceforge.net/projects/qosgpl/files/QNAP%20NAS%20Tool%20Chains/)
  
  - [Marvell](https://sourceforge.net/projects/qosgpl/files/QNAP%20NAS%20Tool%20Chains/)