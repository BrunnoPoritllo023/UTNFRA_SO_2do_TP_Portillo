#!/bin/bash
# Punto A - LVM - Ejemplo siguiendo machete

set -e

# Listar discos (ver cuál es sdb, sdc)
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT

# Supongamos /dev/sdb (1GB) y /dev/sdc (2GB) - ajustar si tu precondicion creó otros nombres
# Crear PVs
sudo pvcreate /dev/sdb /dev/sdc

# Crear VG vg_datos (usamos los dos discos)
sudo vgcreate vg_datos /dev/sdb /dev/sdc

# Crear LVs
sudo lvcreate -L 5M -n lv_docker vg_datos
sudo lvcreate -L 1536M -n lv_workareas vg_datos   # 1.5GB -> 1536M

# Para swap creamos otro VG (o usar mismo si pide)
sudo vgcreate vg_temp /dev/sdb1 2>/dev/null || true
sudo lvcreate -L 512M -n lv_swap vg_datos || true

# Formateos y montajes
sudo mkfs.ext4 /dev/vg_datos/lv_docker
sudo mkfs.ext4 /dev/vg_datos/lv_workareas
sudo mkswap /dev/vg_datos/lv_swap

sudo mkdir -p /var/lib/docker /work
sudo mount /dev/vg_datos/lv_docker /var/lib/docker
sudo mount /dev/vg_datos/lv_workareas /work
sudo swapon /dev/vg_datos/lv_swap

# Persistir en /etc/fstab
echo "/dev/vg_datos/lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/vg_datos/lv_workareas /work ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/vg_datos/lv_swap none swap sw 0 0" | sudo tee -a /etc/fstab
