#!/bin/sh

result=$(cat)
descr=$1

package_loss=$(echo "$result" | grep "packet loss" | cut -d" " -f 6 | tr -d "%")
roundtrip=$(echo "$result" | grep "rtt" | cut -d " " -f 4 | cut -d "/" -f 2)

echo ping_package_loss{descr=\"$descr\"} $package_loss
if [ "$roundtrip" != '' ] ; then echo "ping_roundtrip{descr=\"$descr\"} $roundtrip"; fi
