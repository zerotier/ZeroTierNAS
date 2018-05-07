#!/bin/bash

# Iterate over cross-compiled ZT binaries and build packages for each
# Only builds for the version given

# Run this script from the same directory as build.sh in the Synology folder

CROSSDIR='../../cross-compiled-binaries'
DSM_VERSION='6.1'
SRC_ZT_VERSION='1.2.8'
SRC_COMMIT_SHA='22301a459970dc557c4959104afe418d4b2d6bb1'
DST_ZT_VERSION='1.2.8r0'
OUTPUT_DIR='../../finished-packages'

rm -rf ${OUTPUT_DIR}
mkdir -p ${OUTPUT_DIR}

for dir in $(ls ${CROSSDIR})
do
    dir=${dir%*/}
    if [[ $dir == *${DSM_VERSION} ]]; then
        PACKAGE_ARCH="${dir#work-}"
        echo ${PACKAGE_ARCH}

        ZT_BINARY=${CROSSDIR}/$dir/ZeroTierOne-${SRC_COMMIT_SHA}/zerotier-one
        echo ${ZT_BINARY}

        if [ -f ${ZT_BINARY} ] ; then
            echo "OK"
            # copy cross-compiled binary into package folder
            cp -f ${ZT_BINARY} app/bin
            # make the package
            ./build.sh
            # remove the binary to prevent mixups
            rm -f app/bin/${ZT_BINARY}
            cp dist/zerotier-${DST_ZT_VERSION}-noarch.spk ${OUTPUT_DIR}/zerotier-${DST_ZT_VERSION}-syn-${PACKAGE_ARCH}.spk
        else
            echo "File does not exist. Not building."
        fi
    fi
done