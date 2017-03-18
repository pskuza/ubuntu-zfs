#!/usr/bin/env bash

# customize these
export NEWUSER="user"
export NEWHOSTNAME="temp.local"

# uncomment if you have a cache folder or server
#export RSYNC_CACHE_SERVER="user@192.168.255.57:./.apt-cache"

# for nullmailer, it is advised to not use your personal account
# but create a separate account just for system status emails
#export GMAIL_USER=""
#export GMAIL_PASSWORD=""

# server or desktop install
#export INSTALL_TYPE="server"
export INSTALL_TYPE="desktop"

# disks to use for zfs root pool
export DISKS="/dev/sda /dev/sdb /dev/sdc /dev/sdd"

export ZFS_ROOT_POOL="system"
# zfs root raid usually is "" for 1 disk, mirror for more
#export ZFS_ROOT_ZRAID="mirror"
# comment size to use whole disk
export ZFS_ROOT_SIZE="100G"

# comment to not create data pool
export ZFS_DATA_POOL="userdata"
# zfs data raid can be "" for 1 disk, or for more disks: "", mirror, raidz, raidz2, raidz3
#export ZFS_DATA_ZRAID="mirror"

# don't touch below
export UBUNTU_CODENAME="$(lsb_release -c -s)"
export DEBIAN_FRONTEND=noninteractive
