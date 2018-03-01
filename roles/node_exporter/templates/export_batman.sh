#!/bin/sh
for batdev in /sys/class/net/bat*; do
	test -d ${batdev} || exit 0
	batdev=$(basename $batdev)
	/sbin/ethtool -S ${batdev} | awk -v batdev=${batdev} '
		/^     .*:/ {
			gsub(":", "");
			print "batman_" $1 "{batdev=\"" batdev "\"} " $2
		}
	'
done
