#!/bin/bash
# Copyright (C) 2011-2015 ZeroTier, Inc.

source /pkgscripts/include/pkg_util.sh

package="ZeroTierOne"
version="1.1.4"
displayname="ZeroTierOne"
maintainer="Synology Inc."
arch="$(pkg_get_unified_platform)"
description="ZeroTier virtual private networks for your NAS!"
[ "$(caller)" != "0 NULL" ] && return 0
pkg_dump_info