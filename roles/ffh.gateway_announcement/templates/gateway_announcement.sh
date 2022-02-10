#!/bin/sh

BATCTL=/usr/sbin/batctl

# DEPRECATED in batman v2020.4
#GW_MODE=/sys/class/net/bat%/mesh/gw_mode
#GW_BANDWIDTH=/sys/class/net/bat%/mesh/gw_bandwidth

off() {
	find /sys/class/net/bat* | cut -d '/' -f 5 | sed 's_bat__' | xargs -I X $BATCTL meshif batX gw off
	systemctl stop isc-kea-dhcp4-server
}

on() {
	find /sys/class/net/bat* | cut -d '/' -f 5 | sed 's_bat__' | xargs -I X $BATCTL meshif batX gw server
	systemctl start isc-kea-dhcp4-server
}

## ensure that we announce the highest bandwidth
#for i in 0 10 11 12 13 14 15 16 17 18 19 20 21 22 23 99 ; do
#	[ -f $(echo $GW_BANDWIDTH | sed "s_%_${i}_") ] || continue
#	echo "96MBit/96MBit" > $(echo $GW_BANDWIDTH | sed "s_%_${i}_")
#done

if [ "$1" = '--force-off' ]; then
	off
	exit 0
fi

# we assume that the mark and the routing table number are the same
mark=$(cat /etc/iproute2/rt_tables | grep freifunk | cut -d" " -f 1)
interface=$(ip route get 100.100.0.1 mark ${mark} 2>/dev/null | head -n 1 | sed 's_^.*dev \([^ ]*\).*$_\1_g')

if [ "$interface" = "" ]; then
	logger -p local3.error "no default route found in table freifunk. turning off batman gw mode"
	off
	exit
fi

if ping -q -I ${interface} 100.100.0.1 -c 4 -W 5 >/dev/null; then
	on
else
	logger -p local3.error "ping to 100.100.0.1 (anycast) dev $interface failed. turning off batman gw mode"
	off
fi
