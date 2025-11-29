URLS=(
  # "https://downloads.openwrt.org/releases/24.10.4/targets/armsr/armv7/openwrt-24.10.4-armsr-armv7-generic-squashfs-combined-efi.img.gz"
  # "https://downloads.openwrt.org/releases/24.10.4/targets/armsr/armv8/openwrt-24.10.4-armsr-armv8-generic-squashfs-combined-efi.img.gz"
  "https://downloads.openwrt.org/releases/24.10.4/targets/x86/64/openwrt-24.10.4-x86-64-generic-squashfs-combined-efi.img.gz"
  "https://downloads.openwrt.org/releases/24.10.4/targets/x86/64/openwrt-24.10.4-x86-64-generic-squashfs-combined.img.gz"
  "https://downloads.openwrt.org/releases/24.10.4/targets/x86/64/openwrt-24.10.4-x86-64-generic-ext4-combined.img.gz"

  # "https://downloads.openwrt.org/releases/24.10.4/targets/x86/generic/openwrt-24.10.4-x86-generic-generic-squashfs-combined.img.gz"
  # "https://downloads.openwrt.org/releases/24.10.4/targets/armsr/armv7/openwrt-24.10.4-armsr-armv7-generic-squashfs-rootfs.img.gz"
  # "https://downloads.openwrt.org/releases/24.10.4/targets/armsr/armv8/openwrt-24.10.4-armsr-armv7-generic-squashfs-rootfs.img.gz"
  # "https://downloads.openwrt.org/releases/24.10.4/targets/x86/64/openwrt-24.10.4-x86-64-generic-ext4-combined.img.gz"
  # "https://downloads.openwrt.org/releases/24.10.4/targets/x86/64/openwrt-24.10.4-x86-64-generic-ext4-combined-efi.img.gz"
)

for url in "${URLS[@]}"; do
  filename=$(basename "$url")
  base="${filename%.gz}"
  vdi_name="${base%.img}.vdi"

  echo "=== download $filename ==="
  wget -q "$url" -O "$filename"
  gunzip -f "$filename"
done



for file in *.img; do
  echo $file
  base="${file%.gz}"


  dd if=/dev/zero bs=1M count=4096 >> $file
  # parted $file
  # print
  # resizepart 2 100%
  # print
  # quit
  parted --script $file \
    print \
    resizepart 2 100% \
    print

  fdisk -l $file

  ls -lh

  VBoxManage convertfromraw --format VDI $file $base.vdi
  VBoxManage modifyhd --resize 512 $base.vdi

done


ls -lh