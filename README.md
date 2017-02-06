Synology DiskStation NAS + ZeroTier
======

[![irc](https://img.shields.io/badge/IRC-%23zerotier%20on%20freenode-orange.svg)](https://webchat.freenode.net/?channels=zerotier)


### Building the Standard DSM 6.0 Package
 - The official DSM package will be available in the *Package Center*, if you need to build it yourself, here are the instructions (tested on CentOS 7):
 - Install Apache Ant
 - Fetch dependencies:

```
export ANT_HOME=/usr/share/ant/ 
ant -f $ANT_HOM/fetch.xml -Ddest=system
```

### Generate GPG Key
`gpg --gen-key`
 - (1) RSA Key
 - Choose size
 - Enter name, email
 - Enter a passphrase (leave blank, otherwise the build process will fail)

After successful generation, the key will be placed in `~/.gnupg/`

To verify the key generation was successful: `gpg -K`, use the key id outputted from this in the `build.xml` file.
If successful, copy it into the `package/zerotier/gpg` folder and then build:

 - Build package:
 ```
 ./package/zerotier/build.sh
 ```

### Entware-ng
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

