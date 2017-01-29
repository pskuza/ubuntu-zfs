#!/usr/bin/env bash
set -e
set -x

MAILTO=$(cat /root/.forward | head -n1)
[ "x" = "x${MAILTO}" ] && MAILTO="root"

OUTFILE="/etc/zfs/zed.d/zed.rc"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
sed -i "s;^#*ZED_EMAIL_ADDR=.*;ZED_EMAIL_ADDR=\"${MAILTO}\";" ${OUTFILE}
sed -i "s;^#*ZED_EMAIL_PROG=.*;ZED_EMAIL_PROG=\"sendmail\";" ${OUTFILE}
sed -i "s;^#*ZED_EMAIL_OPTS=.*;ZED_EMAIL_OPTS=\"@ADDRESS@\";" ${OUTFILE}
sed -i "s;^#*ZED_NOTIFY_INTERVAL_SECS=.*;ZED_NOTIFY_INTERVAL_SECS=3600;" ${OUTFILE}
sed -i "s;^#*ZED_NOTIFY_VERBOSE=.*;ZED_NOTIFY_VERBOSE=1;" ${OUTFILE}

# other options
#ZED_SPARE_ON_CHECKSUM_ERRORS=10
#ZED_SPARE_ON_IO_ERRORS=1
