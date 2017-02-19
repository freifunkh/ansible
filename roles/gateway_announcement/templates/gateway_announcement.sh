#!/bin/sh

GW_MODE=/sys/class/net/bat0/mesh/gw_mode
GW_BANDWIDTH=/sys/class/net/bat0/mesh/gw_bandwidth

off() {
	echo off > $GW_MODE || logger -p local3.error "batman gw mode failed: off"
	systemctl stop isc-dhcp-server
}

on() {
	echo server > $GW_MODE || logger -p local3.error "batman gw mode failed: server"
	systemctl start isc-dhcp-server
}

# ensure that we announce the highest bandwidth
echo "96MBit/96MBit" > $GW_BANDWIDTH

if [ "$1" = '--force-off' ]; then
	echo off > $GW_MODE || (echo "batman gw mode failed: off"; exit 1)
	exit 0
fi

# we assume that the mark and the routing table number are the same
mark=$(cat /etc/iproute2/rt_tables | grep freifunk | cut -d" " -f 1)
interface=$(ip route get 8.8.8.8 mark ${mark} 2>/dev/null | head -n 1 | cut -d " " -f 5)

if [ "$interface" = "" ]; then
	logger -p local3.error "no default route found in table freifunk. turning off batman gw mode"
	off
	exit
fi

if ping -q -I ${interface} 8.8.8.8 -c 4 -W 5 >/dev/null; then
	on
else
	logger -p local3.error "ping to 8.8.8.8 dev $interface failed. turning off batman gw mode"
	off
fi
