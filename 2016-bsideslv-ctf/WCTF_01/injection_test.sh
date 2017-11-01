#!/bin/bash

source ./params.sh

aireplay-ng -9 -e "$STATION_ESSID" -a "$STATION_BSSID" "$MY_DEVICE" 
 
