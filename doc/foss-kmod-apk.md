## No longer necessary

### The problem
Since snapshot is currently on `apk`, one may get this error when upstream gets a newer kernel.

```bash
root@OpenWrt ~ # apk add tailscale
ERROR: unable to select packages:
  kernel-6.6.60~a59ba0c2e57510a4215b673a9b7cba9f-r1:
    breaks: kmod-tun-6.6.61-r1[kernel=6.6.61~a59ba0c2e57510a4215b673a9b7cba9f-r1]
    satisfies: world[kernel] kmod-ath11k-ahb-6.6.60.6.11.2-r1[kernel=6.6.60~a59ba0c2e57510a4215b673a9b7cba9f-r1]
               kmod-usb3-6.6.60-r1[kernel=6.6.60~a59ba0c2e57510a4215b673a9b7cba9f-r1]
               .....................
```

there is no need to upgrade the whole system and can be worked around.

In `/etc/apk/repositories.d/distfeeds.list`, we have(for the foss build, this shows a running system with 6.6.60 kernel while upstream is 6.6.61).

```
https://downloads.openwrt.org/snapshots/targets/qualcommax/ipq807x/packages/packages.adb
https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/base/packages.adb
https://downloads.openwrt.org/snapshots/targets/qualcommax/ipq807x/kmods/6.6.60-1-a59ba0c2e57510a4215b673a9b7cba9f/packages.adb
https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/luci/packages.adb
https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/packages/packages.adb
https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/routing/packages.adb
https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/telephony/packages.adb
```

The first line  includes some important packages along with all *latest* kmods and the 3rd line is the kmod feed 
matching current running system, `apk` gets two entries for each kmod once the current system is outdated, throws error when trying to install (newer) kmods.

### The fix

Edit `/etc/apk/repositories.d/distfeeds.list` and add an `@main` tag to first line

```
@main https://downloads.openwrt.org/snapshots/targets/qualcommax/ipq807x/packages/packages.adb
https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/base/packages.adb
https://downloads.openwrt.org/snapshots/targets/qualcommax/ipq807x/kmods/6.6.60-1-a59ba0c2e57510a4215b673a9b7cba9f/packages.adb
https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/luci/packages.adb
https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/packages/packages.adb
https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/routing/packages.adb
https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/telephony/packages.adb
```

This *deprioritizes* the 1st line, making `apk` use proper untagged feed from 3rd line for kmod. For more details, check [Alphine document](https://wiki.alpinelinux.org/wiki/Repositories#Repository_pinning).

installation should complete without error:
```bash
apk update && apk add tailscale
```

For packages from first line, say `qosify`:
```bash
root@OpenWrt ~ # apk add qosify
ERROR: unable to select packages:
  qosify-2024.09.20~1501e093-r1:
    masked in: @main
    satisfies: world[qosify]
root@OpenWrt ~ # apk add qosify@main
(1/8) Installing kmod-ifb (6.6.60-r1)
Executing kmod-ifb-6.6.60-r1.post-install
......
#finish without error
```

