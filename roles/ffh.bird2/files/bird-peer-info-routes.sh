#!/usr/bin/bash

for proto in $( /usr/sbin/birdc show proto | grep "BGP" | awk '{ print $1 }' ); do
	/usr/local/sbin/bird-peer-info.pl $proto
done
