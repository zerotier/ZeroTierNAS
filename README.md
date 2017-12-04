## Network Attached Storage (NAS) and Personal Cloud Devices

<a href="https://www.zerotier.com"><img src="https://github.com/zerotier/ZeroTierOne/raw/master/artwork/AppIcon_87x87.png" align="left" hspace="20" vspace="6"></a>

<hr>

Pre-Built Binaries/Packages Here: [zerotier.com/download.shtml](https://zerotier.com/download.shtml?pk_campaign=github_ZeroTierNAS)

**Got a question or feature request?** Join us on [stackoverflow](http://stackoverflow.com/questions/tagged/zerotier), or [![irc](https://img.shields.io/badge/IRC-%23zerotier%20on%20freenode-orange.svg)](https://webchat.freenode.net/?channels=zerotier)

## Supported Devices:

### Synology

Step 1: See [which chip architecture](https://github.com/SynoCommunity/spksrc/wiki/Architecture-per-Synology-model) your device has.

Step 2: Download the correct package for your specific device.

DSM 6.1+:

| Architecture | Download |
| --- | --- |
| x64  | [zerotier-synology-x64.spk](https://download.zerotier.com/dist/zerotier-synology-x64.spk?pk_campaign=github_zerotiernas) |
| x86  | [zerotier-synology-x86.spk](https://download.zerotier.com/dist/zerotier-synology-x86.spk?pk_campaign=github_zerotiernas) |
| 88f6281  | [zerotier-synology-88f6281.spk](https://download.zerotier.com/dist/zerotier-synology-88f6281.spk?pk_campaign=github_zerotiernas) |
| alpine  | [zerotier-synology-alpine.spk](https://download.zerotier.com/dist/zerotier-synology-alpine.spk?pk_campaign=github_zerotiernas) |
| apollolake  | [zerotier-synology-apollolake.spk](https://download.zerotier.com/dist/zerotier-synology-apollolake.spk?pk_campaign=github_zerotiernas) |
| armada370  | [zerotier-synology-armada370.spk](https://download.zerotier.com/dist/zerotier-synology-armada370.spk?pk_campaign=github_zerotiernas) |
| armada375  | [zerotier-synology-armada375.spk](https://download.zerotier.com/dist/zerotier-synology-armada375.spk?pk_campaign=github_zerotiernas) |
| armada38x  | [zerotier-synology-armada38x.spk](https://download.zerotier.com/dist/zerotier-synology-armada38x.spk?pk_campaign=github_zerotiernas) |
| armadaxp  | [zerotier-synology-armadaxp.spk](https://download.zerotier.com/dist/zerotier-synology-armadaxp.spk?pk_campaign=github_zerotiernas) |
| avoton  | [zerotier-synology-avoton.spk](https://download.zerotier.com/dist/zerotier-synology-avoton.spk?pk_campaign=github_zerotiernas) |
| braswell  | [zerotier-synology-braswell.spk](https://download.zerotier.com/dist/zerotier-synology-braswell.spk?pk_campaign=github_zerotiernas) |
| broadwell  | [zerotier-synology-broadwell.spk](https://download.zerotier.com/dist/zerotier-synology-broadwell.spk?pk_campaign=github_zerotiernas) |
| bromolow  | [zerotier-synology-bromolow.spk](https://download.zerotier.com/dist/zerotier-synology-bromolow.spk?pk_campaign=github_zerotiernas) |
| cedarview  | [zerotier-synology-cedarview.spk](https://download.zerotier.com/dist/zerotier-synology-cedarview.spk?pk_campaign=github_zerotiernas) |
| comcerto2k  | [zerotier-synology-comcerto2k.spk](https://download.zerotier.com/dist/zerotier-synology-comcerto2k.spk?pk_campaign=github_zerotiernas) |
| denverton  | [zerotier-synology-denverton.spk](https://download.zerotier.com/dist/zerotier-synology-denverton.spk?pk_campaign=github_zerotiernas) |
| evansport  | [zerotier-synology-evansport.spk](https://download.zerotier.com/dist/zerotier-synology-evansport.spk?pk_campaign=github_zerotiernas) |
| grantley  | [zerotier-synology-grantley.spk](https://download.zerotier.com/dist/zerotier-synology-grantley.spk?pk_campaign=github_zerotiernas) |
| hi3535  | [zerotier-synology-hi3535.spk](https://download.zerotier.com/dist/zerotier-synology-hi3535.spk?pk_campaign=github_zerotiernas) |
| monaco  | [zerotier-synology-monaco.spk](https://download.zerotier.com/dist/zerotier-synology-monaco.spk?pk_campaign=github_zerotiernas) |
| powerpc  | [zerotier-synology-powerpc.spk](https://download.zerotier.com/dist/zerotier-synology-powerpc.spk?pk_campaign=github_zerotiernas) |
| qoriq  | [zerotier-synology-qoriq.spk](https://download.zerotier.com/dist/zerotier-synology-qoriq.spk?pk_campaign=github_zerotiernas) |
| rtd1296  | [zerotier-synology-rtd1296.spk](https://download.zerotier.com/dist/zerotier-synology-rtd1296.spk?pk_campaign=github_zerotiernas) |

| Model | CPU | Supported | Download | Notes |
| --- | --- | --- | --- | --- |
| DS216+II  | Intel Celeron N3060          | YES | [zerotier-one.spk](https://download.zerotier.com/dist/zerotier-one.spk) | |
| DS916+    | Intel Pentium N3710          | YES | [zerotier-one.spk](https://download.zerotier.com/dist/zerotier-one.spk) | |
| DS414j    | MindSpeed Comcerto 2000, ARM | YES | [zerotier-one.spk](https://download.zerotier.com/dist/zerotier-one.spk) | |
| DS413j    | Marvell, ARM                 | YES | [zerotier-one.spk](https://download.zerotier.com/dist/zerotier-one.spk) | |
| DS1515+   | Intel Atom C2538             | YES | [zerotier-one.spk](https://download.zerotier.com/dist/zerotier-one.spk) | |
| DS3615xs  | Intel Core i3-4130           | YES | [zerotier-one.spk](https://download.zerotier.com/dist/zerotier-one.spk) | |
| DS214play | Intel Atom CE5335            | YES | [zerotier-one.spk](https://download.zerotier.com/dist/zerotier-one.spk) | |

*Note, Synology devices not listed here might still work, we just haven't tested them yet. Give it a shot! If you're interested in us supporting something that isn't on this page, find out [which CPU it uses](https://www.synology.com/en-us/knowledgebase/DSM/tutorial/General/What_kind_of_CPU_does_my_NAS_have) and let us know.*

### QNAP

| Model | CPU | Supported | Download | Notes |
| --- | --- | --- | --- | --- |
| TS-251  | Intel Atom    | YES                               | [ZeroTier_1.2.4_x86_64.qpkg](https://download.zerotier.com/dist/ZeroTier_1.2.4_x86_64.qpkg) | No GUI |
| TS-453A | Intel Celeron | PENDING                           | [ZeroTier_1.2.4_x86_64.qpkg](https://download.zerotier.com/dist/ZeroTier_1.2.4_x86_64.qpkg) | No GUI |
| TS-869L | Intel Atom    | YES [requires QVPN service](http://docs.qnap.com/nas/4.3/cat2/en/index.html?qvpn.htm)       | [ZeroTier_1.2.4_x86_64.qpkg](https://download.zerotier.com/dist/ZeroTier_1.2.4_x86_64.qpkg) | No GUI |
*For 32-bit `QNAP` devices, download [ZeroTier_1.2.4_x86.qpkg](https://download.zerotier.com/dist/ZeroTier_1.2.4_x86.qpkg)*

### WD

| Model | CPU | Supported | Download | Notes |
| --- | --- | --- | --- | --- |
| MyCloud EX2 Ultra | | YES | [WDMyCloudEX2Ultra_zerotier.bin](https://download.zerotier.com/dist/WDMyCloudEX2Ultra_zerotier.bin) | No GUI |
| MyCloud EX2       | | YES | [WDMyCloudEX2_zerotier.bin](https://download.zerotier.com/dist/WDMyCloudEX2_zerotier.bin)           | No GUI |
| MyCloud EX4       | | YES | [WDMyCloudEX4_zerotier.bin](https://download.zerotier.com/dist/WDMyCloudEX4_zerotier.bin)           | No GUI |
