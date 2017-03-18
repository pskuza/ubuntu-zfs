Based on https://github.com/zfsonlinux/zfs/wiki/Ubuntu-16.04-Root-on-ZFS

## ON UBUNTU-DESKTOP LIVECD

as root:

```
apt update ; apt install -y git ; git clone https://github.com/johnko/ubuntu-zfs ; cd ubuntu-zfs
# edit env.sh
vi env.sh
./install.sh
```

## BACKUP APT CACHE

```
backup-apt-cache.sh
```
