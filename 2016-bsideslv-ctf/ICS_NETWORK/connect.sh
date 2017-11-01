iwconfig wlan1 mode Managed essid WCTF_01 key 49:6E:73:65:63:74:4C:65:67:65:6E:64:73

iwconfig wlan1

ifconfig wlan1

echo pulling an ip...
exec dhclient wlan1
