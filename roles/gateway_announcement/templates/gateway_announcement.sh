#!/bin/sh

GW_MODE=/sys/class/net/bat0/mesh/gw_mode
GW_BANDWIDTH=/sys/class/net/bat0/mesh/gw_bandwidth

# ensure that we announce the highest bandwidth
echo "96MBit/96MBit" > $GW_BANDWIDTH

if ping -q -I internetz-me 8.8.8.8 -c 4 -W 5 >/dev/null; then
	echo server > $GW_MODE || logger "batman gw mode failed: server"
	systemctl start isc-dhcp-server
else
	echo off > $GW_MODE || logger "batman gw mode failed: off"
	systemctl stop isc-dhcp-server
fi
