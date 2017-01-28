#!/usr/bin/env bash
set -e
set -x

if [ -z "${UBUNTU_CODENAME}" ]; then
  echo "ERROR: missing env UBUNTU_CODENAME" >&2
  exit 1
fi

OUTFILE="/etc/apt/sources.list"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
cat >${OUTFILE} <<EOF
deb http://archive.ubuntu.com/ubuntu ${UBUNTU_CODENAME} main universe
deb http://archive.ubuntu.com/ubuntu ${UBUNTU_CODENAME}-updates main universe
deb http://security.ubuntu.com/ubuntu ${UBUNTU_CODENAME}-security main universe
deb-src http://archive.ubuntu.com/ubuntu ${UBUNTU_CODENAME} main universe
deb-src http://archive.ubuntu.com/ubuntu ${UBUNTU_CODENAME}-updates main universe
deb-src http://security.ubuntu.com/ubuntu ${UBUNTU_CODENAME}-security main universe
EOF
if [ -z "${RSYNC_CACHE_SERVER}" ]; then
  apt update
fi

apt dist-upgrade -y

PACKAGES="
ubuntu-minimal
linux-image-generic
debootstrap gdisk zfs-initramfs mdadm
grub-pc
openssh-server
rsync
git
curl
wget
ubuntu-standard
nullmailer
docker.io
iftop
pv
tmux
build-essential
ucarp
w3m
zsync
fail2ban
"

for i in ${PACKAGES}; do
  case "${i}" in
    linux-image-generic)
      apt install -y --no-install-recommends ${i}
      ;;
    *)
      apt install -y ${i}
      ;;
  esac
done

if [ "${INSTALL_TYPE}" = "desktop" -a ! -f /etc/system-setup ]; then
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
  cat >/etc/apt/sources.list.d/virtualbox.list <<EOF
deb http://download.virtualbox.org/virtualbox/debian xenial contrib
EOF
  if [ -z "${RSYNC_CACHE_SERVER}" ]; then
    apt update
  fi
  PACKAGES="
dbus
xubuntu-desktop
network-manager-openconnect-gnome
xsel
vagrant
virtualbox-5.1
gimp
inkscape
audacity
filezilla
chromium-browser
"
  for i in ${PACKAGES}; do
    case "${i}" in
      *)
        apt install -y ${i}
        ;;
    esac
  done
fi
