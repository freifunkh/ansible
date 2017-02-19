#!/bin/sh

GW_MODE=/sys/class/net/bat0/mesh/gw_mode
GW_BANDWIDTH=/sys/class/net/bat0/mesh/gw_bandwidth

# ensure that we announce the highest bandwidth
echo "96MBit/96MBit" > $GW_BANDWIDTH

if [ "$1" = '--force-off' ]; then
	echo off > $GW_MODE || (echo "batman gw mode failed: off"; exit 1)
	exit 0
fi

# we assume that the mark and the routing table number are the same
mark=$(cat /etc/iproute2/rt_tables | grep freifunk | cut -d" " -f 1)
interface=$(ip route get 8.8.8.8 mark ${mark} | head -n 1 | cut -d " " -f 5)

if ping -q -I ${interface} 8.8.8.8 -c 4 -W 5 >/dev/null; then
	echo server > $GW_MODE || logger "batman gw mode failed: server"
	systemctl start isc-dhcp-server
else
	echo off > $GW_MODE || logger "batman gw mode failed: off"
	systemctl stop isc-dhcp-server
fi
