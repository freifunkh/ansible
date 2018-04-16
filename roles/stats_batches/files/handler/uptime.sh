#!/bin/sh

# creation of the proc-fs
since=$(stat -c %Z /proc)
now=$(date +%s)

delta=$(expr $now - $since)

echo uptime $delta
