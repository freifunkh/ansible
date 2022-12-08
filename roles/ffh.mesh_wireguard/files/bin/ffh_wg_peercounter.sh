#!/bin/sh
wg show all dump | awk '
BEGIN {
	i = 1;
	while ( "cat /etc/wireguard/peers-wg/ufu-*" | getline a > 0 ) {
		i=i+1;
		ufu[i]=a;
	}
	t = systime();
};
{
	if ((t-$6)<180) {
		for (key in ufu) {
			if (ufu[key] == $2) {
				print $1 " ufu";
			}
		}
		print $1 " all"
	}
};
END {}' | sort | uniq -c | awk '
BEGIN {};
{
    print "wireguard_device,name=" $2 ",type=linux_kernel,group=" $3 " established_peers=" $1 "i " (systime()*1e9)
};
END {}'
