#!/bin/bash

source ./params.sh

echo replaying auth
aireplay-ng -3 -b "$STATION_BSSID" -h "$MY_MAC" "$MY_DEVICE"

