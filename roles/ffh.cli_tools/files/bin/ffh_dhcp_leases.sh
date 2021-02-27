#!/bin/sh

if [ -f /usr/sbin/dhcpd ]; then
	# ISC DHCP SERVER (legacy)
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
elif [ -f /usr/sbin/kea-dhcp4 ]; then
	# KEA DHCP SERVER

	lease_count=$(sudo /etc/zabbix/bin/kea-dhcp4-server.master.sh | \
		jq '.arguments["cumulative-assigned-addresses"][0][0]-.arguments["reclaimed-leases"][0][0]')

	echo [
	echo '     { "domain": "all", "state": "used", "count": '"$lease_count"' }'
	echo ]
fi
