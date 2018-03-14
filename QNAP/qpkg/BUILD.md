#### Package Build Instructions:

 - Clone this repo and [ZeroTierOne](https://github.com/zerotier/ZeroTierOne/tree/master)
 
 - In [ZeroTierOne](https://github.com/zerotier/ZeroTierOne/tree/master) repo, `make one ZT_QNAP=1`
 
 - Copy resultant `zerotier-one` into appropriate platform folder `QNAP/x86`, `QNAP/x86_64`, etc.
 
 - `tar -cvf qnap.tar`

 - On the QNAP system, install the [QDK](http://download.qnap.com/Storage/Utility/QDK_2.2.4.zip)
 
 - Go to dev directory defined by: `getcfg QDK Install_Path -f /etc/config/qpkg.conf` 

 - Copy previously mentioned `qnap.tar` to your QNAP system and untar it in the dev directory under `zerotier`

 - On QNAP System, enter `zerotier` directory and run `qbuild`

 - Tar up the result and send it back to your dev system.

 #### For developers:

 Toolchains:

  - [x86](https://sourceforge.net/projects/qosgpl/files/QNAP%20NAS%20Tool%20Chains/)
  
  - [Marvell](https://sourceforge.net/projects/qosgpl/files/QNAP%20NAS%20Tool%20Chains/)