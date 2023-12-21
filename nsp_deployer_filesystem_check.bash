#!/bin/bash

# Script to check the required filesystem size of the NSP deployer
# Mark Hollis 2023-12-21


# Define a list of filesystem sizes to check (ensure sizes are appended with M or G)
ROOT=26G
HOME=500M
TMP=4G
VAR=64G
VARLOG=6G
VARLOGAUDIT=6G
OPT=275G


# Convert filesystem values to bytes
B_ROOT=$(numfmt --from=iec $ROOT)
B_HOME=$(numfmt --from=iec $HOME)
B_TMP=$(numfmt --from=iec $TMP)
B_VAR=$(numfmt --from=iec $VAR)
B_VARLOG=$(numfmt --from=iec $VARLOG)
B_VARLOGAUDIT=$(numfmt --from=iec $VARLOGAUDIT)
B_OPT=$(numfmt --from=iec $OPT)


# Output data from lsblk to a temporary file and read each line to check the filesystem sizes
/usr/bin/lsblk -rnb > lsblk.txt
while IFS=" " read -r -a line; do
  if [ "${line[6]}" = "/" ] && [ "${line[3]}" -lt "$B_ROOT" ]
    then
    echo "The ${line[6]} filesystem is below the minimum size."
    exit 1
  elif [ "${line[6]}" = "/home" ] && [ "${line[3]}" -lt "$B_HOME" ]
    then
    echo "The ${line[6]} filesystem is below the minimum size."
    exit 1
  elif [ "${line[6]}" = "/tmp" ] && [ "${line[3]}" -lt "$B_TMP" ]
    then
    echo "The ${line[6]} filesystem is below the minimum size."
    exit 1
  elif [ "${line[6]}" = "/var" ] && [ "${line[3]}" -lt "$B_VAR" ]
    then
    echo "The ${line[6]} filesystem is below the minimum size."
    exit 1
  elif [ "${line[6]}" = "/var/log" ] && [ "${line[3]}" -lt "$B_VARLOG" ]
    then
    echo "The ${line[6]} filesystem is below the minimum size."
    exit 1
  elif [ "${line[6]}" = "/var/log/audit" ] && [ "${line[3]}" -lt "$B_VARLOGAUDIT" ]
    then
    echo "The ${line[6]} filesystem is below the minimum size."
    exit 1
  elif [ "${line[6]}" = "/opt" ] && [ "${line[3]}" -lt "$B_OPT" ]
    then
    echo "The ${line[6]} filesystem is below the minimum size."
    exit 1
  fi
done < lsblk.txt

# Remove temporary file
if [ -f lsblk.txt ]
then
  rm lsblk.txt
fi

# Summary of all checks passed
echo "Filesystems meet the minimum recommended sizes."
exit 0
