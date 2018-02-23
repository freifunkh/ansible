#!/bin/sh

if ! ss -tln | grep 33123 >/dev/null; then
	exit 0
fi

echo "dump" | nc ::1 33123 -w 1 | awk '
/^my-id/ {
	myid = $2
}
/^add neighbour/ {
	print "babeld_neigh_rxcost{addr=\"" $5"\",if=\""$7"\"} " $11
	print "babeld_neigh_txcost{addr=\"" $5"\",if=\""$7"\"} " $13
}
/^add interface/ {
	up = ($5 == "true") ? 1 : 0;
	print "babeld_interface_up{addr=\"" $7 "\",if=\"" $3 "\",myid=\"" myid "\"} " up
}
/^add route/ {
	print "babeld_route_metric{route=\"" $5 "\",from=\"" $7 "\",srcid=\"" $11 "\",installed=\"" $9 "\"} " $13
}
'
