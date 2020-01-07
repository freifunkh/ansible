#!/bin/sh

# the addresses of one supernode do only differ in the last octet, so we match for the first five octets
node_id_prefix=$(cat /sys/class/net/bat10/address | cut -d ':' -f 1-5 | tr -d ':')
meshviewer=$(curl --compressed -s "https://harvester.ffh.zone/meshviewer.json" | jq '.nodes | map({ gateway: .gateway, gateway6: .gateway6 })')

get() {
	echo "$meshviewer" | jq 'map(select(.'$1' and (.'$1' | match("^'${node_id_prefix}'")))) | length'
}

echo \[
echo '    { "domain": "all", "ip_version": 4, "count": '$(get gateway)'},'
echo '    { "domain": "all", "ip_version": 6, "count": '$(get gateway6)'}'
echo \]

