#!/bin/bash

source ./params.sh

exec airodump-ng -c "$STATION_CHANNEL" --bssid "$STATION_BSSID" -w hay_capture "$MY_DEVICE"

