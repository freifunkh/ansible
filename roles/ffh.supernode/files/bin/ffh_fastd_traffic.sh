#!/bin/sh

set -e

get_counters() {
	nc -U /var/run/fastd.mesh_fastd_${1}.sock | jq '[.peers[] | select(.connection != null ) | { name: .name, tx_bytes: .connection.statistics.tx.bytes }]'
}

get_names() {
	jq -r '.[].name'
}

get_by_name() {
	jq -r ".[] | select(.name == \"$1\") | .tx_bytes"
}

a() {
	cat /tmp/a.json
}

b() {
	cat /tmp/b.json
}

if [ $# -lt 1 ]; then
    echo "USAGE: $0 DOMAIN_ID"
    exit 1
fi

get_counters $1 > /tmp/a.json
sleep 10
get_counters $1 > /tmp/b.json

for name in $(b | get_names); do
	before=$(a | get_by_name ${name})
	after=$(b | get_by_name ${name})
	printf "%*s: %5d kbit/s\n" 40 ${name} $((($after - $before)/1024*8/10))
done
