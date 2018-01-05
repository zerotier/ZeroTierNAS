## Cross-Compiling and Building ZeroTier Packages for Synology Devices
Using Debian, Docker, spksrc, and the Synology toolchains
*Note: To build for `armv5te`, check the bottom of this document*
***

## Step 1: Cross-Compilation

In this section we will build the `zerotier-one` binary for every architecture offered by Synology.

### Get Latest Release of ZeroTier

`wget` latest ZeroTierOne release from: `https://github.com/zerotier/ZeroTierOne/releases`

 - For example: `wget https://github.com/zerotier/ZeroTierOne/releases/1.2.4.tar.gz`

Compute checksums and place them in `cross/digests` file:

```
shasum -a 1 1.2.4.tar.gz
shasum -a 256 1.2.4.tar.gz
md5 1.2.4.tar.gz
```

Digest file should appear like so:

```
1.2.4.tar.gz SHA1 checksum
1.2.4.tar.gz SHA256 checksum
1.2.4.tar.gz MD5 checksum
```

### Set Up Debian Build Environment

 - Install Debian somewhere

 - Once Debian is installed, install docker CE:

```
sudo apt-get update
```

```
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
```

*Note: The `lsb_release -cs` sub-command below returns the name of your Debian distribution, such as jessie.*

```
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"
```


```
sudo apt-get update
sudo apt-get install docker-ce
```


### Set up spksrc

Run the spksrc container:

```
docker run -it -v ~/spksrc:/spksrc synocommunity/spksrc /bin/bash
```

Install build environment requirements:

```
sudo dpkg --add-architecture i386 && sudo apt-get update
sudo aptitude install build-essential debootstrap python-pip automake libgmp3-dev libltdl-dev libunistring-dev libffi-dev libcppunit-dev ncurses-dev imagemagick libssl-dev pkg-config zlib1g-dev gettext git curl subversion check intltool gperf flex bison xmlto php5 expect libgc-dev mercurial cython lzip cmake swig libc6-i386 libmount-dev libpcre3-dev libbz2-dev
sudo pip install -U setuptools pip wheel httpie
```

Some packages might require 32-bit versions. For instance,

```
zlib1g-dev:i386
```

Clone spksrc repo:

`git clone https://github.com/SynoCommunity/spksrc.git`

Check out `dsm6` branch if you plan to target DSM version `6.0` or later:

`git checkout dsm6`

See the following: https://github.com/SynoCommunity/spksrc/wiki/Developers-HOW-TO

Set default toolchain version

### spk/package/Makefile

```
SPK_NAME = ZeroTierOne
SPK_VERS = 1.2.4
SPK_REV = 0
SPK_ICON = src/zerotier.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = ZeroTier, Inc.
DESCRIPTION = A Simple global P2P encrypted LAN for all of your devices.
DESCRIPTION_FRE = Un réseau local crypté P2P simple et global pour tous vos appareils.
DESCRIPTION_SPN = Una LAN global P2P cifrada fácil para todos sus dispositivos.
ADMIN_PORT = 9993
RELOAD_UI = yes
DISPLAY_NAME = ZeroTier
CHANGELOG = ""

HOMEPAGE = https://www.zerotier.com
LICENSE  = GPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/
WIZARDS_DIR      = src/wizard/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = transmission_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: transmission_extra_install
transmission_extra_install:
  install -m 755 -d $(STAGING_DIR)/var
  install -m 644 src/settings.json $(STAGING_DIR)/var/settings.json
  install -m 755 -d $(STAGING_DIR)/app
  install -m 644 src/app/config $(STAGING_DIR)/app/config
```


### cross/package/Makefile
```
PKG_NAME = ZeroTierOne
PKG_VERS = 1.2.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/zerotier/ZeroTierOne/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.zerotier.com
COMMENT  = A Simple global P2P encrypted LAN for all of your devices.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = HAVE_CXX=yes

ENV+=ZT_SYNOLOGY=1
REQUIRED_DSM=6.1

include ../../mk/spksrc.cross-cc.mk
```


### cross/package/digests
```
1.2.4.tar.gz SHA1 82b2040bd5e7d6064b5d652612b4aaade2b0a236
1.2.4.tar.gz SHA256 9f275b3732b721f02cc4b8df75b51e6a8fb56dfe1a542a7bd681538d852b0358
1.2.4.tar.gz MD5 f0b127bd0919e8af841336cd70a954a6
```


### cross/package/PLIST
```
bin:bin/zerotier-one
bin:bin/zerotier-cli
bin:bin/zerotier-idtool
```

 - Disable th call to configure in `unknown_file:50`

***





## Step 1 (alternative): ARMv5TE based models

This category is separate because ZeroTier currently requires certin C++11 features that are not available in Synology's official toolchains targeting DSM 5.2. For this reason we employ a different build process for the binary. The process for building the package will remain the same however and will be detailed below this section.

In this section we will be building a docker cross-compiler container for ARM

Tweaks specific to building ZeroTier:

 - Disable NEON
 - Compile static with: `ZT_STATIC=1` and thus, `LDFLAGS+=-static-libstdc++`

Much of the following content of this file was taken from [David Herron's write-up](https://techsparx.com/software-development/docker-arm-cross-compile.html) over at TECHSPARX. This file is for personal reference only and tweaked specifically for our portability efforts with the ZeroTier codebase.

Dockerfile:

```
FROM debian:jessie

RUN apt-get update && apt-get install -y \
    apt-utils \
    curl \
    build-essential \
    automake \
    autogen \
    bash \
    build-essential \
    bc \
    bzip2 \
    ca-certificates \
    curl \
    file \
    git \
    gzip \
    make \
    ncurses-dev \
    pkg-config \
    libtool \
    python \
    rsync \
    sed \
    bison \
    flex \
    tar \
    vim \
    wget \
    runit \
    xz-utils \
    nano \
    net-tools

RUN echo "deb http://emdebian.org/tools/debian jessie main" > /etc/apt/sources.list.d/emdebian.list
RUN curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -
RUN dpkg --add-architecture armel
RUN apt-get update && apt-get install -y crossbuild-essential-armel

# The cross-compiling emulator
RUN apt-get update && apt-get install -y \
    qemu-user \
    qemu-user-static

RUN git clone https://github.com/zerotier/ZeroTierOne.git
```

Build and run the container:

```
docker build --tag emdebian-for-technologic .
docker run -it --volume `pwd`:/workdir emdebian-for-technologic bash
```

Set environment to use our new cross-compiler:

```
export CXX=arm-linux-gnueabi-g++
export CC=arm-linux-gnueabi-gcc
export STRIP=arm-linux-gnueabi-strip
```

Build ZeroTier:

`make one ZT_STATIC=1 ZT_SYNOLOGY=1`

The resultant binary `zerotier-one` can now be used in the Synology package building process.

***





## Step 2: Building the DSM Package

Here we package the `zerotier-one` binary into a DSM-compatible archive for installation.

### Set up the environment to build a package:

 - Install Apache Ant
 - Fetch dependencies:

```
export ANT_HOME=/usr/share/ant/ 
ant -f $ANT_HOME/fetch.xml -Ddest=system
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

### Build

 - Place `zerotier-one` binary in `ZeroTierNAS/Synology/package/zerotier/app/bin`
 - From `ZeroTierNAS/Synology/package/zerotier`, run `./build.sh`
 - Resultant package will be placed in `ZeroTierNAS/Synology/package/zerotier/dist`

### Internal Semi-Automated Process for Building all Varieties of Synology Packages

 - Cross-compile to desired targets
  - Enter repo container: `docker run -it -v ~/spksrc:/spksrc synocommunity/spksrc /bin/bash`
  - Set desired DSM version for toolchain (local.mk, Makefile)
  - Change directory to: `spksrc/spksrc/cross/zerotier`
  - Build all architectures: `make all-archs`
  - Remove unneeded files in work directories: `find work* -type f ! -name 'zerotier-one' -delete`
  - Compress resultant binaries: `tar -cvf cross-compiled-binaries.tar.gz .`
  - Move binaries to packaging VM `scp cross-compiled-binaries.tar.gz user@1.2.3.4:/media/psf/Home/ZeroTierNAS/Synology`
 - Build packages
  - `mkdir -p cross-compiled-binaries finished-packages`
  - Uncompress binaries into staging dir: `tar -xvf cross-compiled-binaries.tar.gz -C cross-compiled-binaries`
  - Change directory to: `ZeroTierNAS/Synology/package/zerotier`
  - Update text and version info in: `ZeroTierNAS/Synology/package/zerotier/build.xml`
  - Run `./../../packgen.sh`

***




## Usage

### Controlling the service

 - Start: `synoservice --start pkgctl-zerotier`
 - Stop: `synoservice --stop pkgctl-zerotier`
 - Status: `synoservice --status pkgctl-zerotier`
 - Restart: `synoservice --restart pkgctl-zerotier`

 Logs are stored in: `/var/log/zerotier-one.log`

### Using the service

```
Usage: zerotier-cli [-switches] <command/path> [<args>]

Available switches:
  -h                      - Display this help
  -v                      - Show version
  -j                      - Display full raw JSON output
  -D<path>                - ZeroTier home path for parameter auto-detect
  -p<port>                - HTTP port (default: auto)
  -T<token>               - Authentication token (default: auto)

Available commands:
  info                    - Display status info
  listpeers               - List all peers
  listnetworks            - List all networks
  join <network>          - Join a network
  leave <network>         - Leave a network
  set <network> <setting> - Set a network setting
  listmoons               - List moons (federated root sets)
  orbit <world ID> <seed> - Join a moon via any member root
  deorbit <world ID>      - Leave a moon
```
