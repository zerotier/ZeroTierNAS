Synology DiskStation NAS + ZeroTier
======

###Building the Standard DSM 6.0 Package
 - The official DSM package will be available in the *Package Center*, if you need to build it yourself, here are the instructions (tested on CentOS 7):
 - Install Apache Ant
 - Fetch dependencies:

```
export ANT_HOME=/usr/share/ant/ 
ant -f $ANT_HOM/fetch.xml -Ddest=system
```

 - Build package:
 ```
 ./package/zerotier/build.sh
 ```

###Entware-ng
 - Alterntively without a GUI, an official ZeroTier package exists for Entware-ng under the name `zerotier`
 - Follow these instructions to install Entware-ng on your Synology NAS: https://github.com/Entware-ng/Entware-ng/wiki/Install-on-Synology-NAS
 - `opkg install zerotier`
 - Modify `package/zerotier/spk/scripts/start-stop-status.sh` script to start and stop ZeroTier. Entware will likely install ZeroTier to `/volumeX/@entware-ng/opt/usr/sbin/`
***

*
Side notes:
 - If required, additional installation instructions can be found here: http://ant.apache.org/manual/install.html
 - If installing Ant from a repo it might not include `fetch.xml` or `get-m2.xml`, copy these into your `$ANT_HOME` manually.
*

