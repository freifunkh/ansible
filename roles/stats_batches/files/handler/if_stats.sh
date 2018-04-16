#!/bin/sh

interface_stats() {
	interface=$1
	result=$(ip -s link show $interface)

	# helper function
	line() { head -n "$1" | tail -n 1; }
	trim_whitespace() { sed 's/[\ ]\+/ /g'; }

	bytes_rx=$(echo "$result" | line 4 | trim_whitespace | cut -d " " -f 2)
	bytes_tx=$(echo "$result" | line 6 | trim_whitespace | cut -d " " -f 2)
	packets_rx=$(echo "$result" | line 4 | trim_whitespace | cut -d " " -f 3)
	packets_tx=$(echo "$result" | line 6 | trim_whitespace | cut -d " " -f 3)

	echo if_bytes_rx{interface=\"$interface\"} $bytes_rx
	echo if_bytes_tx{interface=\"$interface\"} $bytes_tx
	echo if_packets_rx{interface=\"$interface\"} $packets_rx
	echo if_packets_rx{interface=\"$interface\"} $packets_rx
}

interfaces=$(ls /sys/class/net)

for i in $interfaces; do
	interface_stats $i
done;
