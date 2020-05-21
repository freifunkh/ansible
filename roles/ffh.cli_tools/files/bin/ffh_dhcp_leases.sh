#!/bin/sh

count_leases() {
	echo "$leases" | grep $1 | wc -l
}

leases=$(grep -e "^ *binding state" /var/lib//dhcp/dhcpd.leases)

echo [
for state in free used touched defined; do
	echo -n '     { "domain": "all", "state": "'${state}'", "count": '$(dhcpd-pools -f j | jq "[.subnets[].${state}] | add")' }'

	if [ "$state" = "defined" ]; then
		echo 
	else
		echo ,
	fi
done
echo ]

