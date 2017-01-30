#!/usr/bin/env bash
set -e
set -x

OLD_UMASK=$(umask)
umask 0077
exec 1> >(tee /var/log/01-system-setup.log)
exec 2>&1
umask ${OLD_UMASK}

cd /root/ubuntu-zfs

. ./env.sh

: ${NEWHOSTNAME=unassigned-hostname}
: ${ZFS_ROOT_POOL=system}

if [ -z "${DISKS}" ]; then
  echo "ERROR: missing env DISKS" >&2
  exit 1
fi

#passwd

install -d -m 700 -o root -g root /root/.vim
install -d -m 700 -o root -g root /root/.vim/backups
install -d -m 700 -o root -g root /root/.vim/swaps
install -d -m 700 -o root -g root /root/.vim/undo
if [ -d /root/ubuntu-zfs/skel ]; then
  for i in /root/ubuntu-zfs/skel/.* /root/ubuntu-zfs/skel/*; do
    case ${i##*/} in
      . | ..)
        echo "Skipping ${i##*/}"
        ;;
      *)
        OUTFILE="/root/${i##*/}"
        [ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
        [ -f ${i} ] && install -m 600 -o root -g root ${i} ${OUTFILE}
        if [ -d ${i} ]; then
          cp -a ${i} /root
          chown -R root:root ${OUTFILE}
          # remove group and other permissions
          find ${OUTFILE} -exec chmod go-rwx {} \;
        fi
        ;;
    esac
  done
fi

touch /etc/system-setup
./change-hostname.sh ${NEWHOSTNAME}

./setup-network-interfaces.sh

locale-gen en_US.UTF-8
#dpkg-reconfigure locales
OUTFILE="/etc/default/locale"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
cat >${OUTFILE} <<EOF
LANG="en_US.UTF-8"
EOF

#dpkg-reconfigure tzdata
ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime

ln -s /proc/self/mounts /etc/mtab

./apt-install.sh
rm /etc/system-setup

for file in /etc/logrotate.d/* ; do
  if grep -Eq "(^|[^#y])compress" "$file" ; then
    sed -i -r "s/(^|[^#y])(compress)/\1#\2/" "$file"
  fi
done

#service docker stop || true
#OUTFILE="/etc/default/docker"
#[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
#cat >>${OUTFILE} <<EOF
#DOCKER_OPTS="--storage-driver=zfs"
#EOF
#service docker start || true

./setup-sshd_config.sh

addgroup --system lpadmin
addgroup --system sambashare
addgroup --system docker

#grub-probe /
update-initramfs -c -k all
OUTFILE="/etc/default/grub"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
sed -i 's;quiet splash;;' ${OUTFILE}
update-grub
for k in 1 2; do
  sleep 2
  for i in ${DISKS}; do
    grub-install ${i}
  done
  ls /boot/grub/*/zfs.mod
done

OUTFILE="/etc/modprobe.d/zfs.conf"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
cat >>${OUTFILE} <<EOF
# Min 512MB / Max 1024 MB Limit
options zfs zfs_arc_min=536870912
options zfs zfs_arc_max=1073741824
EOF

install -m 755 update-issue.local /etc/update-issue.local
ln -sf /etc/update-issue.local /etc/network/if-down.d/update-issue.local
ln -sf /etc/update-issue.local /etc/network/if-up.d/update-issue.local

install -m 700 firstboot.local /etc/firstboot.local
install -m 700 firstboot /etc/init.d/firstboot
ln -sf /etc/init.d/firstboot /etc/rc2.d/S99firstboot
ln -sf /etc/init.d/firstboot /etc/rc3.d/S99firstboot
ln -sf /etc/init.d/firstboot /etc/rc4.d/S99firstboot
ln -sf /etc/init.d/firstboot /etc/rc5.d/S99firstboot
touch /etc/firstboot

zfs snapshot -r ${ZFS_ROOT_POOL}@00-install
