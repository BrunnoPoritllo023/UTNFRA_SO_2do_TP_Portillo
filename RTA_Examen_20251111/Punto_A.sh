
set -e


lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT


sudo pvcreate /dev/sdb /dev/sdc


sudo vgcreate vg_datos /dev/sdb /dev/sdc


sudo lvcreate -L 5M -n lv_docker vg_datos
sudo lvcreate -L 1536M -n lv_workareas vg_datos   


sudo vgcreate vg_temp /dev/sdb1 2>/dev/null || true
sudo lvcreate -L 512M -n lv_swap vg_datos || true


sudo mkfs.ext4 /dev/vg_datos/lv_docker
sudo mkfs.ext4 /dev/vg_datos/lv_workareas
sudo mkswap /dev/vg_datos/lv_swap

sudo mkdir -p /var/lib/docker /work
sudo mount /dev/vg_datos/lv_docker /var/lib/docker
sudo mount /dev/vg_datos/lv_workareas /work
sudo swapon /dev/vg_datos/lv_swap


echo "/dev/vg_datos/lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/vg_datos/lv_workareas /work ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/vg_datos/lv_swap none swap sw 0 0" | sudo tee -a /etc/fstab
