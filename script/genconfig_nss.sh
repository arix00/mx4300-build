#!/bin/sh

ver="snapshot" #snapshot or release#
buildkmod="y"

[ ! -z $1 ] && ver=$1
[ ! -z $2 ] && buildkmod=$2

echo > .config

if [ "$ver" = "snapshot" ]; then
  mainpath="https://downloads.openwrt.org/snapshots/targets/qualcommax/ipq807x"
else
  mainpath="https://downloads.openwrt.org/releases/$ver/targets/qualcommax/ipq807x"
fi


if [ "${buildkmod}" != "n" ]; then
  jsonpath=$(wget ${mainpath}/sha256sums -O - | grep index.json -m 1 | cut -d '*' -f 2 | xargs)
  kmods=$(wget ${mainpath}/${jsonpath} -O - | jq '.packages' | grep \"kmod | cut -d '"' -f 2)
  #kmods=$(echo "$kmods" | grep -v ath | grep -v kmod-bonding | grep -v vxlan | grep -v kmod-nat46)
  kmods=$(echo "$kmods" | grep -v ath)
  echo extra kmods: $(echo $kmods | wc -w)
fi

cat nss-setup/config-nss.seed |  grep -v CONFIG_PACKAGE_luci >> .config
echo "
CONFIG_TARGET_qualcommax_ipq807x_DEVICE_linksys_mx4300=y
CONFIG_PACKAGE_luci=y
CONFIG_FEED_nss_packages=n
" >> .config
make defconfig

for k in $kmods; do grep -q $k=y .config || echo CONFIG_PACKAGE_$k=m >> .config; done
make defconfig

cat .config | grep kmod-qca | grep -v "not set"
