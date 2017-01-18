Synology DiskStation NAS + ZeroTier
======

###Entware-ng
 - An official ZeroTier package exists for Entware-ng under the name `zerotier`
 - Follow these instructions to install Entware-ng on your Synology NAS: https://github.com/Entware-ng/Entware-ng/wiki/Install-on-Synology-NAS
 - `opkg install zerotier`
 - Use the `start-stop-status.sh` script found in the `hacky` directory to start and stop ZeroTier
***

###Hacky way
 - There are two packaging solutions included in this repo. The first [hacky](hacky) way which is essentially bare bones ZeroTier running with a few extra scripts added to help make controlling and installing it on Synology devices a little easier. This is not a full package as it does not meet all requirements for a DSM 6.0 package.
***

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
 ./ant-spk/zerotier/build.sh
 ```

*
Side notes:
 - If required, additional installation instructions can be found here: http://ant.apache.org/manual/install.html
 - If installing Ant from a repo it might not include `fetch.xml` or `get-m2.xml`, copy these into your `$ANT_HOME` manually.
*

