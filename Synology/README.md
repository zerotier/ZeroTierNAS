ZeroTier for Synology 
======

[![irc](https://img.shields.io/badge/IRC-%23zerotier%20on%20freenode-orange.svg)](https://webchat.freenode.net/?channels=zerotier)

***

Recent Updates:

| Date | Version | Description |
| --- | --- | --- |
| TBA | 1.2.6r0 | Update of ZeroTier core service |
| 2018-01-11 | 1.2.4 | Fixed status indicator for all packages. Fixed need for manually starting service after device restart |

Note:

 - Synology QuickConnect is known to prevent the package GUI from working. We advise that you connect directly while administering your device.

 - After version 1.2.4 we will begin versioning the individual builds of out synology packages: `1.2.6r0`, `1.2.6r1`, etc.

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

If for some reason you want to build your own ZeroTier package, we've included the instructions [here](BUILD.md)


