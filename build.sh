URLS=(
  "https://downloads.openwrt.org/releases/24.10.4/targets/x86/64/openwrt-24.10.4-x86-64-generic-ext4-combined.img.gz"
  "https://downloads.openwrt.org/releases/24.10.4/targets/x86/64/openwrt-24.10.4-x86-64-generic-ext4-combined-efi.img.gz"
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

  VBoxManage convertfromraw --format VDI $file $base.vdi
  VBoxManage modifyhd --resize 512 $base.vdi

done


