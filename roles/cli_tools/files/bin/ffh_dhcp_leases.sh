#!/bin/sh

count_leases() {
	echo "$leases" | grep $1 | wc -l
}

leases=$(grep -e "^ *binding state" /var/lib//dhcp/dhcpd.leases)

echo [
for state in free abandoned active; do
	echo -n '     { "domain": "all", "state": "'${state}'", "count": '$(count_leases $state)' }'

	if [ "$state" = "active" ]; then
		echo 
	else
		echo ,
	fi
done
echo ]

