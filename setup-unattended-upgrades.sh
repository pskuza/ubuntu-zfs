#!/usr/bin/env bash
set -e
set -x

apt install -y unattended-upgrades

OUTFILE="/etc/apt/apt.conf.d/50unattended-upgrades"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
if grep -q '^//.*"${distro_id}:${distro_codename}-updates' ${OUTFILE}; then
  sed -i 's,^//.*"${distro_id}:${distro_codename}-updates.*,"${distro_id}:${distro_codename}-updates";,' ${OUTFILE}
fi
if grep -q "^//Unattended-Upgrade::MinimalSteps" ${OUTFILE}; then
  sed -i 's,^//Unattended-Upgrade::MinimalSteps.*,Unattended-Upgrade::MinimalSteps "true";,' ${OUTFILE}
else
  cat >>${OUTFILE} <<EOF
Unattended-Upgrade::MinimalSteps "true";
EOF
fi
if grep -q "^//Unattended-Upgrade::Mail " ${OUTFILE}; then
  sed -i 's,^//Unattended-Upgrade::Mail .*,Unattended-Upgrade::Mail "root";,' ${OUTFILE}
else
  cat >>${OUTFILE} <<EOF
Unattended-Upgrade::Mail "root";
EOF
fi
if grep -q "^//Unattended-Upgrade::MailOnlyOnError" ${OUTFILE}; then
  sed -i 's,^//Unattended-Upgrade::MailOnlyOnError .*,Unattended-Upgrade::MailOnlyOnError "false";,' ${OUTFILE}
else
  cat >>${OUTFILE} <<EOF
Unattended-Upgrade::MailOnlyOnError "false";
EOF
fi

OUTFILE="/etc/apt/apt.conf.d/10periodic"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
if grep -q "^APT::Periodic::Download-Upgradeable-Packages" ${OUTFILE}; then
  sed -i 's,^APT::Periodic::Download-Upgradeable-Packages.*,APT::Periodic::Download-Upgradeable-Packages "1";,' ${OUTFILE}
else
  cat >>${OUTFILE} <<EOF
APT::Periodic::Download-Upgradeable-Packages "1";
EOF
fi
if grep -q "^APT::Periodic::Update-Package-Lists" ${OUTFILE}; then
  sed -i 's,^APT::Periodic::Update-Package-Lists.*,APT::Periodic::Update-Package-Lists "1";,' ${OUTFILE}
else
  cat >>${OUTFILE} <<EOF
APT::Periodic::Update-Package-Lists "1";
EOF
fi

OUTFILE="/etc/apt/apt.conf.d/20auto-upgrades"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
if grep -q "^APT::Periodic::Update-Package-Lists" ${OUTFILE}; then
  sed -i 's,^APT::Periodic::Update-Package-Lists.*,APT::Periodic::Update-Package-Lists "1";,' ${OUTFILE}
else
  cat >>${OUTFILE} <<EOF
APT::Periodic::Update-Package-Lists "1";
EOF
fi
if grep -q "^APT::Periodic::Unattended-Upgrade" ${OUTFILE}; then
  sed -i 's,^APT::Periodic::Unattended-Upgrade.*,APT::Periodic::Unattended-Upgrade "1";,' ${OUTFILE}
else
  cat >>${OUTFILE} <<EOF
APT::Periodic::Unattended-Upgrade "1";
EOF
fi
