ZeroTier for Synology 
======

[![irc](https://img.shields.io/badge/IRC-%23zerotier%20on%20freenode-orange.svg)](https://webchat.freenode.net/?channels=zerotier)

**Download pre-built packages here:** [zerotier.com/download.shtml](https://zerotier.com/download.shtml?pk_campaign=github_ZeroTierNAS)

***

Due to the varied nature of the Synology NAS lineup it is difficult to ensure complete functional coverage. We do offer packages for most models but some have unique quirks. In most cases the `zerotier-cli` command line interface is the recommended method for using ZeroTier, there is a react-based GUI included but is known to be somewhat buggy.

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

If for some reason you want to build your own ZeroTier package, we've included the instructions [here](BUILD.md)


