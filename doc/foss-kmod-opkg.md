## No longer necessary

### The problem
Snapshot builds evolve quickly, and that sets time limits to install new packages. If you ever get the kernel dependency error:

```
 # opkg install tailscale
Installing tailscale (1.72.1-r1) to root...
Downloading https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/packages/tailscale_1.72.1-r1_aarch64_cortex-a53.ipk
Collected errors:
 * pkg_hash_check_unresolved: cannot find dependency kernel (= 6.6.52~de4052b9bf53ceed6a5d84135bb4f6bd-r1) for kmod-tun
 * satisfy_dependencies_for: Cannot satisfy the following dependencies for tailscale:
 *      kernel (= 6.6.52~de4052b9bf53ceed6a5d84135bb4f6bd-r1)
 * opkg_install_cmd: Cannot install package tailscale.
```

there is no need to upgrade and can be worked around.

In `/etc/opkg/distfeed.conf`, we have(for the foss build)

```
src/gz openwrt_core https://downloads.openwrt.org/snapshots/targets/qualcommax/ipq807x/packages
src/gz openwrt_base https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/base
src/gz openwrt_kmods https://downloads.openwrt.org/snapshots/targets/qualcommax/ipq807x/kmods/6.6.51-1-45634c8621725df6ea20fc891f3b84cb
src/gz openwrt_luci https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/luci
src/gz openwrt_packages https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/packages
src/gz openwrt_routing https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/routing
src/gz openwrt_telephony https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/telephony
```

The first line, `openwrt_core` includes some important packages along with all *latest* kmods and the `openwrt_kmods` line is the kmod feed 
matching current running system, opkg gets two entries for each kmod once the snapshot is outdated, throws error when trying to install (newer) kmods from `openwrt_core`.

### The fix

For most packages, take `tailscale` for example
```
#update opkg database
opkg update

#remove the openwrt_core entry
rm /var/opkg-lists/openwrt_core*

#now install, it will complete without error
opkg install tailscale

#restore
opkg update
```

A little tricky for package in `openwrt_core` feed, say `qosify`.
```
#update opkg database
opkg update

#find package dependcy kmod
opkg info qosify
#Depends: libc, libbpf1, libubox20240329, libubus20231128, libnl-tiny1, kmod-sched-cake, kmod-sched-bpf, kmod-ifb, tc

#get these kmods properly installed
rm /var/opkg-lists/openwrt_core*
opkg install  kmod-sched-cake kmod-sched-bpf kmod-ifb

#add openwrt_core back and install
opkg update
opkg install qosify
```


