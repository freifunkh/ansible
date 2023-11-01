#!/bin/sh

BATCTL=/usr/sbin/batctl

for batdev in $(ip -o link show | awk -F': ' '$2 ~ /^bat/ {print $2}'); do
	/sbin/ethtool -S ${batdev} | awk -v batdev=${batdev} '
		/^     .*:/ {
			gsub(":", "");
			print "batman_" $1 "{batdev=\"" batdev "\"} " $2
		}
	'

	echo "batman_originator_count_non_selected{batdev=\"${batdev}\",selected=\"false\"}" $($BATCTL meshif ${batdev} o | egrep '^   ' | wc -l)
	echo "batman_originator_count_selected{batdev=\"${batdev}\",selected=\"true\"}" $($BATCTL meshif ${batdev} o | egrep '^ \*' | wc -l)
	echo "batman_tg_count_multicast{batdev=\"${batdev}\",type=\"multicast\"}" $(($($BATCTL meshif ${batdev} tg -m | wc -l)-2))
	echo "batman_tg_count_unicast{batdev=\"${batdev}\",type=\"unicast\"}" $(($($BATCTL meshif ${batdev} tg -u | wc -l)-2))
done
