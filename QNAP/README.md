ZeroTier packages for QNAP 
==

**Download pre-built packages here:** [zerotier.com/download.shtml](https://zerotier.com/download.shtml)

## Usage:

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


## Picking the correct package:
*Note: Due to the lack of documentation on architecture designations selecting the correct package is an inexact science, as far as I can discerne there are the following categories:*

***

### x86

[ZeroTier_1.2.4-qnap-x86.qpkg](https://download.zerotier.com/dist/zerotier_1.2.4-qnap-x86.qpkg?pk_campaign=github_zerotiernas)

```
TS-x51 Series, TS-x51+ Series, TS-x51A Series, TS-x53B Series, TS-x53A Series, TS-x53U Series TS-239 Pro, TS-239 Pro II, TS-239 Pro II+, TS-251, TS-253A, TS-259 Pro, TS-259 Pro+, TS-269L, TS-439 Pro II, TS-451, TS-459 Pro, TS-439 Pro, TS-459U-RP+/SP+, TS-439 Pro II+, TS-459 Pro II, TS-459 Pro+, TS-459U-RP/SP, SS-439-Pro TS-469L, TS-651, TS-851
```

***

### x86_64

[ZeroTier_1.2.4-qnap-x86_64.qpkg](https://download.zerotier.com/dist/zerotier_1.2.4-qnap-x86_64.qpkg?pk_campaign=github_zerotiernas)

***

### arm-x09

`?`

***

### arm-x19

[ZeroTier_1.2.4-qnap-arm-x19.qpkg](https://raw.githubusercontent.com/zerotier/download.zerotier.com/master/htdocs/RELEASES/1.2.4/dist/zerotier_1.2.4-qnap-arm-x19.qpkg)

```
TS-119P II, TS-119P+, TS-119, TS-219P, TS-219, TS-219P II, TS-219P+, TS-221, TS-419U II, TS-419P, TS-419U II, TS-439U-RP/SP TS-419P II, TS-419P+, TS-419U+, TS-419U, SS-439-Pro
```

***

### arm-x31

[ZeroTier_1.2.4-qnap-arm-x31.qpkg](https://download.zerotier.com/dist/zerotier_1.2.4-qnap-arm-x31.qpkg?pk_campaign=github_zerotiernas)

```
TS-131, TS-231 ,TS-231+, TS-431, TS-431+
```

***

### arm-x41

[zerotier_1.2.4-qnap-arm-x41.qpkg](https://download.zerotier.com/dist/zerotier_1.2.4-qnap-arm-x41.qpkg?pk_campaign=github_zerotiernas)

```
TS-128, TS-131P, TS-231P, TS-231P2
```
