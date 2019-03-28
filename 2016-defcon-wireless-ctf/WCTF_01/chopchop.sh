#!/bin/bash

source ./params.sh

exec aireplay-ng -4 -b "$STATION_BSSID" -h "$MY_MAC" "$MY_DEVICE"

