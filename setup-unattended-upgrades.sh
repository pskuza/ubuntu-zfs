#!/usr/bin/env bash
set -e
set -x

apt install -y unattended-upgrades

OUTFILE="/etc/apt/apt.conf.d/50unattended-upgrades"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original

if grep -q "^//Unattended-Upgrade::MinimalSteps" ${OUTFILE}; then
  sed -i 's,^//Unattended-Upgrade::MinimalSteps.*,Unattended-Upgrade::MinimalSteps "true";,' ${OUTFILE}
fi

if grep -q "^//Unattended-Upgrade::Mail" ${OUTFILE}; then
  sed -i 's,^//Unattended-Upgrade::Mail.*,Unattended-Upgrade::Mail "root";,' ${OUTFILE}
fi

OUTFILE="/etc/apt/apt.conf.d/10periodic"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original

if grep -q "^APT::Periodic::Download-Upgradeable-Packages" ${OUTFILE}; then
  sed -i 's/^APT::Periodic::Download-Upgradeable-Packages.*/APT::Periodic::Download-Upgradeable-Packages "1";/' ${OUTFILE}
else
  cat >>${OUTFILE} <<EOF
APT::Periodic::Download-Upgradeable-Packages "1";
EOF
fi

if grep -q "^APT::Periodic::Unattended-Upgrade" ${OUTFILE}; then
  sed -i 's/^APT::Periodic::Unattended-Upgrade.*/APT::Periodic::Unattended-Upgrade "1";/' ${OUTFILE}
else
  cat >>${OUTFILE} <<EOF
APT::Periodic::Unattended-Upgrade "1";
EOF
fi
