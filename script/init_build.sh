#!/bin/sh

type="foss"  #foss nss
ver="snapshot" #snapshot or release#

[ ! -z $1 ] && type=$1
[ ! -z $2 ] && ver=$2

if [ $type = "foss" ]; then
    #use official PR from testuser7
    PATCH="https://github.com/openwrt/openwrt/pull/16070.diff"
elif [ $type = "nss" -a $ver = "snapshot" ]; then
    #my PR for qosmio NSS patch, may subject to change
    PATCH="https://github.com/arix00/openwrt-mx4300/pull/39.diff"
elif [ $type = "nss" -a $ver != "snapshot" ]; then
    #TBA. patch for 24.10 branch
    PATCH="https://github.com/arix00/openwrt-mx4300/pull/41.diff"
else
    echo "Unsupported build: $type $ver"
    exit 1
fi    



wget $PATCH -O mx4300.diff
patch -p1 < mx4300.diff
