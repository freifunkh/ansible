#!/bin/sh

load=$(cat /proc/loadavg | cut -d " " -f 1)

echo "load{timedelta=\"1\"}" $load
