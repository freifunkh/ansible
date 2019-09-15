#!/bin/sh

data=$(echo dump | nc ::1 33123 -w 1)

filter_whitespace () {
	grep -v '^\s*$'
}

count_lines () {
	# wc -l is not suitable as it counts empty lines
	awk 'BEGIN{c=0}NF{c++}END{print c}'
}

d () {
	echo -n "$data"
}

echo "INTERFACES:"
echo

d | grep interface

ifaces=$(d | grep interface | cut -d " " -f 3)

TOK_10="route 10\\." 
TOK_100="route 100\\." 
TOK_2a02="route 2a02:790:ff:"

xroute_10=$(d | grep "$TOK_10" | count_lines)
xroute_100=$(d | grep "$TOK_100" | count_lines)
xroute_2a02=$(d | grep "$TOK_2a02" | count_lines)
xroute_rest=$(d | grep "xroute" | grep -v "$TOK_10" | grep -v "$TOK_2a02" | grep -v "$TOK_100" )
xroute_rest_cnt=$(echo "$xroute_rest" | count_lines)

echo
echo "NEIGHBOURS:"
echo

d | grep neighbour | cut -d " " -f 6-

echo
echo "EXPORTED ROUTES:"
echo

echo "ipv4 routes beginning with 10..           : $xroute_10"
echo "ipv4 routes beginning with 100..          : $xroute_100"
echo "ipv6 routes beginning with 2a02:790:ff:...: $xroute_2a02"
echo "other routes                              : $xroute_rest_cnt"
echo
if [ $xroute_rest_cnt -gt 0 ]; then
	echo "other routes are:"
	echo
	echo "$xroute_rest"
fi

echo --------
echo

for iface in $ifaces; do

ifroutes_total () {
	d | grep "add route" | grep "if $iface" 
}

ifroutes() {
	ifroutes_total | grep "installed yes"
}

ifroutes_deact() {
	ifroutes_total | grep "installed no"
}

if [ $(ifroutes_total | count_lines) -lt 1 ]; then
continue
fi 

echo "IMPORTED ROUTES via $iface: ($(ifroutes | count_lines))"
echo

TOK_10="prefix 10\\." 
TOK_100="prefix 100\\." 
TOK_2a02="prefix 2a02:790:ff:"

xroute_10=$(ifroutes | grep "$TOK_10" | count_lines)
xroute_100=$(ifroutes | grep "$TOK_100" | count_lines)
xroute_2a02=$(ifroutes | grep "$TOK_2a02" | count_lines)
xroute_rest=$(ifroutes | grep -v "$TOK_10" | grep -v "$TOK_2a02" | grep -v "$TOK_100" )
xroute_rest_cnt=$(echo "$xroute_rest" | count_lines)

fmt_route () {
	cut -d " " -f 4-7,12-15,8,9
}

echo "inactive routes                                  : $(ifroutes_deact | count_lines)"
echo "active routes                                    : $(ifroutes | count_lines)"
echo "routes total                                     : $(ifroutes_total | count_lines)"
echo
echo "active ipv4 routes beginning with 10..           : $xroute_10"
echo "active ipv4 routes beginning with 100..          : $xroute_100"
echo "active ipv6 routes beginning with 2a02:790:ff:...: $xroute_2a02"
echo "active other routes                              : $xroute_rest_cnt"
echo
if [ $xroute_rest_cnt -gt 0 ]; then
	echo "other active routes are:"
	echo
	echo "$xroute_rest" | fmt_route
fi

echo ---
echo 

done
