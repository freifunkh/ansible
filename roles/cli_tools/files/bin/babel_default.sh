#!/bin/sh

data=$(echo dump | nc -N ::1 33123)

d () {
	echo -n "$data"
}

fmt_route () {
	cut -d " " -f 4-7,12-15,8,9,18,19
}

echo "NEIGHBOURS:"
echo

d | grep neighbour | cut -d " " -f 6-

echo
echo IPv6:
echo
d | grep "prefix ::/0" | fmt_route
echo
echo IPv4:
echo
d | grep "prefix 0.0.0.0/0" | fmt_route

