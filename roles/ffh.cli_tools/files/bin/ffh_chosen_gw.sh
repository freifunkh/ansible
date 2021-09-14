#!/bin/sh

# the addresses of one supernode do only differ in the 4th and last octet, so we match for the four octets
node_id_prefix=$(cat /sys/class/net/bat10/address | cut -d ':' -f 1-3 | tr -d ':')..$(cat /sys/class/net/bat10/address | cut -d ':' -f 5 | tr -d ':')
meshviewer=$(curl --compressed -s "https://harvester.ffh.zone/api/meshviewer.json" | jq '.nodes | map({ gateway: .gateway, gateway6: .gateway6})')

get() {
	echo "$meshviewer" | jq 'map(select(.'$1' and (.'$1' | gsub(":";"") | match("^'${node_id_prefix}'")))) | length'
}

echo \[
echo '    { "domain": "all", "ip_version": 4, "count": '$(get gateway)'},'
echo '    { "domain": "all", "ip_version": 6, "count": '$(get gateway6)'}'
echo \]
