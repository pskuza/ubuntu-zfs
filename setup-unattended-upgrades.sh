#!/usr/bin/env bash
set -e
set -x

MAILTO=$(cat /root/.forward | head -n1)
[ "x" = "x${MAILTO}" ] && MAILTO="root"

apt install -y unattended-upgrades

OUTFILE="/etc/apt/apt.conf.d/50unattended-upgrades"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
sed -i 's,^//.*"${distro_id}:${distro_codename}-updates.*,"${distro_id}:${distro_codename}-updates";,' ${OUTFILE}
sed -i 's,^//Unattended-Upgrade::MinimalSteps.*,Unattended-Upgrade::MinimalSteps "true";,' ${OUTFILE}
if ! grep -q "^Unattended-Upgrade::MinimalSteps" ${OUTFILE}; then
  cat >>${OUTFILE} <<EOF
Unattended-Upgrade::MinimalSteps "true";
EOF
fi
sed -i "s,^//Unattended-Upgrade::Mail .*,Unattended-Upgrade::Mail \"${MAILTO}\";," ${OUTFILE}
if ! grep -q "^Unattended-Upgrade::Mail " ${OUTFILE}; then
  cat >>${OUTFILE} <<EOF
Unattended-Upgrade::Mail "${MAILTO}";
EOF
fi
sed -i 's,^//Unattended-Upgrade::MailOnlyOnError .*,Unattended-Upgrade::MailOnlyOnError "false";,' ${OUTFILE}
if ! grep -q "^Unattended-Upgrade::MailOnlyOnError" ${OUTFILE}; then
  cat >>${OUTFILE} <<EOF
Unattended-Upgrade::MailOnlyOnError "false";
EOF
fi

OUTFILE="/etc/apt/apt.conf.d/10periodic"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
sed -i 's,^APT::Periodic::Download-Upgradeable-Packages.*,APT::Periodic::Download-Upgradeable-Packages "1";,' ${OUTFILE}
if ! grep -q "^APT::Periodic::Download-Upgradeable-Packages" ${OUTFILE}; then
  cat >>${OUTFILE} <<EOF
APT::Periodic::Download-Upgradeable-Packages "1";
EOF
fi
sed -i 's,^APT::Periodic::Update-Package-Lists.*,APT::Periodic::Update-Package-Lists "1";,' ${OUTFILE}
if ! grep -q "^APT::Periodic::Update-Package-Lists" ${OUTFILE}; then
  cat >>${OUTFILE} <<EOF
APT::Periodic::Update-Package-Lists "1";
EOF
fi

OUTFILE="/etc/apt/apt.conf.d/20auto-upgrades"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
sed -i 's,^APT::Periodic::Update-Package-Lists.*,APT::Periodic::Update-Package-Lists "1";,' ${OUTFILE}
if ! grep -q "^APT::Periodic::Update-Package-Lists" ${OUTFILE}; then
  cat >>${OUTFILE} <<EOF
APT::Periodic::Update-Package-Lists "1";
EOF
fi
sed -i 's,^APT::Periodic::Unattended-Upgrade.*,APT::Periodic::Unattended-Upgrade "1";,' ${OUTFILE}
if ! grep -q "^APT::Periodic::Unattended-Upgrade" ${OUTFILE}; then
  cat >>${OUTFILE} <<EOF
APT::Periodic::Unattended-Upgrade "1";
EOF
fi
