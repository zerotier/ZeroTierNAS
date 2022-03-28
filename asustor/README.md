ZeroTier APKs for ASUSTOR 
==

## Picking the correct package:

Our package is bundled with a set of static binaries compatible with `x86-64`, `i386`, and `aarch64` chipsets. So it's likely to be compatible with most models. If this is not the case for you please open a ticket and indicate your model and `ADM` version. Note: There is no GUI as of yet.

 - *Pre-built ASUSTOR APKs: [https://download.zerotier.com/dist/asustor/](https://download.zerotier.com/dist/asustor/)*

 - *Download other packages here:* [https://zerotier.com/download.shtml](https://zerotier.com/download.shtml)

## Troubleshooting steps specific to ASUSTOR

- Make sure you're using the `zerotier-cli` as root.
- If ZeroTier doesn't work immediately after install try restarting at least once.
- If ZeroTier *still* doesn't work. Try `modprobe tun` and check with `ls /dev/tun`
- Check that ZeroTier is running: `ps`
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

## Building package from source

For those of you who do not trust pre-built packages or found this repo in the year 2077, here are rough instructions for how to build the APK yourself. These instructions were last tested on Ubuntu Server with python 2.7 installed.

1) Cross-compile ZeroTier using ASUSTOR's own toolchain (available here: [developer.asustor.com](developer.asustor.com)) or by statically linking against a compatible standard library. For reference, we build and distribute the raw statically-linked artifacts here: [download.zerotier.com/dist/static-binaries/](https://download.zerotier.com/dist/static-binaries/)
2) Place the resultant binaries in the `zerotier/bin` package directory and name them according to their target architecture (our `zerotier/CONTROL/post-install.sh` script will look for these specific names during install and use the correct one automatically.):

```
zerotier
├── bin
│   ├── zerotier-one.aarch64
│   ├── zerotier-one.i386
│   └── zerotier-one.x86-64
...
```

3) Assuming you've changed nothing in the package directory other than the binaries you're ready to package everything up.

4) Package! `sudo ./apkg-tools.py create zerotier`


## Platform notes

 - Since we bundle all of the binaries into a single APK we don't specify a target architecture in the `zerotier/CONTROL/config.json` file. This explains why the resultant APK is named: `zerotier_X.Y.Z_any.apk`
 - APK contents are installed into: `/usr/local/AppCentral/zerotier`
 - Symlinks to things like `zerotier-cli/idtool` are here: `/usr/local/`
