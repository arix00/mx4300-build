This release has most of the kmods(kernel module) prebuilt, to use the binaries:

1. Download and extract the kmods.tar.gz to the router, for example, `/www`.  

   Note: can use other path instead of `/www` as `apk` accepts local file path for feed.

   ```
   #on browser, right click the kmods.tar.gz, then "copy link address"
   wget https://github.com/...../kmods.tar.gz -O /tmp/kmods.tar.gz
   tar xvfz /tmp/kmods.tar.gz -C /www
   ```

2. Edit `/etc/apk/repositories.d/distfeeds.list`, add a new line:
   ```
   /www/kmods/packages.adb
   ```
   
   full file content:
   ```
   https://downloads.openwrt.org/snapshots/targets/qualcommax/ipq807x/packages/packages.adb
   https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/base/packages.adb
   https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/luci/packages.adb
   https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/packages/packages.adb   
   https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/routing/packages.adb
   https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/telephony/packages.adb
   /www/kmods/packages.adb
   ```
   kmod feed is setup and ready for use.
