#!/bin/sh

print_all() {
    for SOCK in $(ls -1 /var/run/fastd.mesh_fastd*.sock)
    do
	DOM=$(echo ${SOCK} | sed -e 's/[^0-9]//g');
	echo -n "Domain ${DOM}: ";
	nc -U ${SOCK} 2>/dev/null | jq '.peers[] | select(.connection != null ) | .name | select( test("^(?!sn\\d+|harvester)"))' | wc -l;
    done
}

print_single() {
    nc -U /var/run/fastd.mesh_fastd_$1.sock 2>/dev/null | jq '.peers[] | select(.connection != null ) | .name | select( test("^(?!sn\\d+|harvester)"))' | wc -l;
}

case "$1" in
    -a) print_all
      ;;
     *) print_single $1
      ;;
esac
