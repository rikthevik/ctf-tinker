#!/bin/bash

source ./params.sh

echo associating with station
exec aireplay-ng -1 0 -e "$STATION_ESSID" -a "$STATION_BSSID" -h "$MY_MAC" "$MY_DEVICE"

