#!/bin/sh
wg show all dump | awk 'BEGIN {}; {if (systime()-$6 <180 ) print $1 } ; END {}' | uniq -c | awk 'BEGIN {}; { print "wireguard_device,name=" $2 ",type=linux_kernel established_peers=" $1 "i " (systime()*1e9) } ; END {}'
