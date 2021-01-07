#!/bin/sh

BATCTL=/usr/sbin/batctl

for batdev in /sys/class/net/bat*; do
	test -d ${batdev} || exit 0
	batdev=$(basename $batdev)
	/sbin/ethtool -S ${batdev} | awk -v batdev=${batdev} '
		/^     .*:/ {
			gsub(":", "");
			print "batman_" $1 "{batdev=\"" batdev "\"} " $2
		}
	'

	echo "batman_originator_count{batdev=\"${batdev}\",selected=\"false\"}" $($BATCTL meshif ${batdev} o | egrep '^   ' | wc -l)
	echo "batman_originator_count{batdev=\"${batdev}\",selected=\"true\"}" $($BATCTL meshif ${batdev} o | egrep '^ \*' | wc -l)
	echo "batman_tg_count{batdev=\"${batdev}\",type=\"multicast\"}" $(($($BATCTL meshif ${batdev} tg -m | wc -l)-2))
	echo "batman_tg_count{batdev=\"${batdev}\",type=\"unicast\"}" $(($($BATCTL meshif ${batdev} tg -u | wc -l)-2))
done
