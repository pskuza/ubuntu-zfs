#!/usr/bin/env bash
set -e
set -x

NEWHOME="/home/${1}"
NEWGROUPS="adm,cdrom,dip,lpadmin,plugdev,sambashare,docker,sudo"
NEWSKEL="/etc/skel"

# password is admin
useradd -d ${NEWHOME} -G ${NEWGROUPS} -m -k ${NEWSKEL} -p '$6$ZukFU3LL$jGgdl2h6oSt/j06odeBaTPyWCwobck.GQA1DJVwEmYkji1DMDMj3WA66dCBpCer5hpavx8ArScr5lLvS4VXMg/' -s /bin/bash -U ${1}

#usermod -a -G ${NEWGROUPS} ${1}

install -d -m 700 -o ${1} -g ${1} ${NEWHOME}/.vim
install -d -m 700 -o ${1} -g ${1} ${NEWHOME}/.vim/backups
install -d -m 700 -o ${1} -g ${1} ${NEWHOME}/.vim/swaps
install -d -m 700 -o ${1} -g ${1} ${NEWHOME}/.vim/undo

mv ${NEWHOME} ${NEWHOME}.original
zfs create system${NEWHOME}
chown -R ${1}:${1} ${NEWHOME}
find ${NEWHOME}.original -maxdepth 1 -mindepth 1 -exec mv {} ${NEWHOME} \;
rmdir ${NEWHOME}.original

if [ -d /root/ubuntu-zfs/skel ]; then
  for i in /root/ubuntu-zfs/skel/.* /root/ubuntu-zfs/skel/*; do
    case ${i##*/} in
      . | ..)
        echo "Skipping ${i##*/}"
        ;;
      *)
        OUTFILE="${NEWHOME}/${i##*/}"
        [ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
        [ -f ${i} ] && install -m 600 -o ${1} -g ${1} ${i} ${OUTFILE}
        if [ -d ${i} ]; then
          cp -a ${i} ${NEWHOME}
          chown -R ${1}:${1} ${OUTFILE}
          # remove group and other permissions
          find ${OUTFILE} -exec chmod go-rwx {} \;
        fi
        ;;
    esac
  done
fi

OUTFILE="/etc/sudoers.d/${1}"
if [ ! -f ${OUTFILE} ]; then
  cat >${OUTFILE} <<EOF
# ${1} ALL=(ALL) NOPASSWD: ALL
${1} ALL=(ALL) ALL
EOF
fi
