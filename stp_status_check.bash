#!/bin/bash

# Script to check if STP is disabled on the Linux bridge
# Mark Hollis 2024-01-17


/bin/nmcli --terse device status | awk -F ":" '$2=="bridge" {print $1}' | while read line; do
  stp_state=$(/sbin/ip -j -p -d link show $line | grep "stp_state" | awk -F ": " '{print $2}' | cut -d "," -f1)
  if [ $stp_state -eq 0 ]; then
    echo "STP is disabled on $line."
  else
    echo "STP is enabled on $line."
  fi
done
