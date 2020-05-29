#!/bin/sh

file=/tmp/apinger.status

awk '
BEGIN {
	timestamp=systime()
}

/^Target: .*\..*/ {
	target=$2
	proto="ipv4"
}

/^Target: .*:.*/ {
	target=$2
	proto="ipv6"
}

/^Description:/ {
	description=substr($0, index($0, $2))
	gsub(" ", "_", description)
}

/^Average delay:/ {
	delay=$3
	sub("ms", "", delay)
}

/^Average packet loss:/ {
	loss=$4
	sub("%", "", loss)
}

/^Received packets buffer:/ {
	print "apinger,description=" description ",target=" target ",proto=" proto " delay=" delay " " timestamp "000000000"
	print "apinger,description=" description ",target=" target ",proto=" proto " loss=" loss " " timestamp "000000000"
}
' ${file}
