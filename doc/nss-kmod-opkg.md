This release has most of the kmods(kernel module) prebuilt, to use the binaries:

1. Download the kmods.tar.gz to the router, extract the content to `/www`. For use with other http server, adjust accordingly.
   ```
   #on browser, right click the kmods.tar.gz, then "copy link address"
   wget https://github.com/...../kmods.tar.gz -O /tmp/kmods.tar.gz

   #extract the file to /www, it's now available at http://openwrt_router_ip/kmods
   tar xvfz /tmp/kmods.tar.gz -C /www

   #or: with usb storage, extract the file there and make a symbolic link in /www
   #tar xvfz /tmp/kmods.tar.gz -C /mnt/sda1
   #ln -s /mnt/sda1/kmods /www
   ```

2. Edit `/etc/opkg/distfeed.conf`, add a new line:
   ```
   src/gz openwrt_kmods http://openwrt_router_ip/kmods
   ```

3. Run `opkg update` and proceed with package installation.
