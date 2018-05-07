ZeroTier for Synology 
======

[![irc](https://img.shields.io/badge/IRC-%23zerotier%20on%20freenode-orange.svg)](https://webchat.freenode.net/?channels=zerotier)

***

- Downloads: [https://download.zerotier.com/RELEASES/](https://download.zerotier.com/RELEASES/)

- See [here](https://github.com/SynoCommunity/spksrc/wiki/Architecture-per-Synology-model) or [here](https://www.synology.com/en-us/knowledgebase/DSM/tutorial/General/What_kind_of_CPU_does_my_NAS_have) to determine which chip architecture your device has. Or just ask and we can help you.

- Synology QuickConnect is known to prevent the package GUI from working. We advise that you connect directly while administering your device.

- If for some reason you want to build your own ZeroTier package, we've included the instructions [here](BUILD.md)

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