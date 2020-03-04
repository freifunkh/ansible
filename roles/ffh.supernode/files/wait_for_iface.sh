#!/bin/sh

while ! [ -d /sys/class/net/$1 ]
do
    echo  "waiting for $1 to appear"
    sleep 1
done

while ! [ "$(cat /sys/class/net/$1/operstate)" = "up" ]
do
    echo  "waiting for $1 to be up"
    sleep 1
done