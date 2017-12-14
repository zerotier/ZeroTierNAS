## Network Attached Storage (NAS) and Personal Cloud Devices

<a href="https://www.zerotier.com"><img src="https://github.com/zerotier/ZeroTierOne/raw/master/artwork/AppIcon_87x87.png" align="left" hspace="20" vspace="6"></a>

<hr>

Pre-Built Binaries/Packages for other devices and platforms can be found here: [zerotier.com/download.shtml](https://zerotier.com/download.shtml?pk_campaign=github_zerotiernas)

**Got a question or feature request?** Join us on [![irc](https://img.shields.io/badge/IRC-%23zerotier%20on%20freenode-orange.svg)](https://webchat.freenode.net/?channels=zerotier)
***

### QNAP

 - For 32-bit `QNAP` devices, download [ZeroTier_1.2.4_x86.qpkg](https://download.zerotier.com/dist/ZeroTier_1.2.4_x86.qpkg?pk_campaign=github_zerotiernas)

| Model | CPU | Supported | Download | Notes |
| --- | --- | --- | --- | --- |
| TS-251  | Intel Atom    | YES                               | [ZeroTier_1.2.4_x86_64.qpkg](https://download.zerotier.com/dist/ZeroTier_1.2.4_x86_64.qpkg?pk_campaign=github_zerotiernas) | No GUI |
| TS-453A | Intel Celeron | PENDING                           | [ZeroTier_1.2.4_x86_64.qpkg](https://download.zerotier.com/dist/ZeroTier_1.2.4_x86_64.qpkg?pk_campaign=github_zerotiernas) | No GUI |
| TS-869L | Intel Atom    | YES [requires QVPN service](http://docs.qnap.com/nas/4.3/cat2/en/index.html?qvpn.htm)       | [ZeroTier_1.2.4_x86_64.qpkg](https://download.zerotier.com/dist/ZeroTier_1.2.4_x86_64.qpkg?pk_campaign=github_zerotiernas) | No GUI |
***

### Netgear ReadyNAS

 - See: https://github.com/NAStools/zerotierone
 
***

### Synology

 - Use the standard `zerotier-cli`. The GUI's reliability varies wildly accross devices.
 - Currently supporting DSM 6.1+
 - See [here](https://github.com/SynoCommunity/spksrc/wiki/Architecture-per-Synology-model) or [here](https://www.synology.com/en-us/knowledgebase/DSM/tutorial/General/What_kind_of_CPU_does_my_NAS_have) to determine which chip architecture your device has. Or just ask and we can help you.

| Architecture | Download |
| --- | --- |
| Intel x64  | [zerotier-1.2.4-syn-x64-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-x64-6.1.spk?pk_campaign=github_zerotiernas) |
| Intel x86  | [zerotier-1.2.4-syn-x86-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-x86-6.1.spk?pk_campaign=github_zerotiernas) |
| Marvell 88f6281  | [zerotier-1.2.4-syn-88f6281-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-88f6281-6.1.spk?pk_campaign=github_zerotiernas) |
| Marvell Armada 370  | [zerotier-1.2.4-syn-armada370.-6.1spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-armada370-6.1.spk?pk_campaign=github_zerotiernas) |
| Marvell Armada 375  | [zerotier-1.2.4-syn-armada375-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-armada375-6.1.spk?pk_campaign=github_zerotiernas) |
| Marvell Armada 38x  | [zerotier-1.2.4-syn-armada38x-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-armada38x-6.1.spk?pk_campaign=github_zerotiernas) |
| Marvell Armada XP  | [zerotier-1.2.4-syn-armadaxp-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-armadaxp-6.1.spk?pk_campaign=github_zerotiernas) |
| Intel Apollo Lake  | [zerotier-1.2.4-syn-apollolake-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-apollolake-6.1.spk?pk_campaign=github_zerotiernas) |
| Intel Avoton  | [zerotier-1.2.4-syn-avoton-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-avoton-6.1.spk?pk_campaign=github_zerotiernas) |
| Intel Braswell  | [zerotier-1.2.4-syn-braswell-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-braswell-6.1.spk?pk_campaign=github_zerotiernas) |
| Intel Broadwell  | [zerotier-1.2.4-syn-broadwell-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-broadwell-6.1.spk?pk_campaign=github_zerotiernas) |
| Intel Bromolow  | [zerotier-1.2.4-syn-bromolow-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-bromolow-6.1.spk?pk_campaign=github_zerotiernas) |
| Intel Cedarview  | [zerotier-1.2.4-syn-cedarview-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-cedarview-6.1.spk?pk_campaign=github_zerotiernas) |
| Intel Denverton  | [zerotier-1.2.4-syn-denverton-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-denverton-6.1.spk?pk_campaign=github_zerotiernas) |
| Intel Evansport  | [zerotier-1.2.4-syn-evansport-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-evansport-6.1.spk?pk_campaign=github_zerotiernas) |
| Intel Grantley  | [zerotier-1.2.4-syn-grantley-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-grantley-6.1.spk?pk_campaign=github_zerotiernas) |
| Mindspeed Comcerto2k  | [zerotier-1.2.4-syn-comcerto2k-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-comcerto2k-6.1.spk?pk_campaign=github_zerotiernas) |
| Annapurna Labs Alpine   | [zerotier-1.2.4-syn-alpine-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-alpine-6.1.spk?pk_campaign=github_zerotiernas) |
| hi3535  | [zerotier-1.2.4-syn-hi3535-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-hi3535-6.1.spk?pk_campaign=github_zerotiernas) |
| STM STiH412 Monaco  | [zerotier-1.2.4-syn-monaco-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-monaco-6.1.spk?pk_campaign=github_zerotiernas) |
| powerpc  | [zerotier-1.2.4-syn-powerpc-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-powerpc-6.1.spk?pk_campaign=github_zerotiernas) |
| qoriq  | [zerotier-1.2.4-syn-qoriq-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-qoriq-6.1.spk?pk_campaign=github_zerotiernas) |
| Realtek RTD1293 / RTD1296  | [zerotier-1.2.4-syn-rtd129x-6.1.spk](https://download.zerotier.com/dist/zerotier-1.2.4-syn-rtd129x-6.1.spk?pk_campaign=github_zerotiernas) |
***

### WD

| Model | CPU | Supported | Download | Notes |
| --- | --- | --- | --- | --- |
| MyCloud EX2 Ultra | | YES | [WDMyCloudEX2Ultra_zerotier.bin](https://download.zerotier.com/dist/WDMyCloudEX2Ultra_zerotier.bin?pk_campaign=github_zerotiernas) | No GUI |
| MyCloud EX2       | | YES | [WDMyCloudEX2_zerotier.bin](https://download.zerotier.com/dist/WDMyCloudEX2_zerotier.bin?pk_campaign=github_zerotiernas)           | No GUI |
| MyCloud EX4       | | YES | [WDMyCloudEX4_zerotier.bin](https://download.zerotier.com/dist/WDMyCloudEX4_zerotier.bin?pk_campaign=github_zerotiernas)           | No GUI |
