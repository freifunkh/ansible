#!/bin/sh

while ! [ -d /sys/class/net/$1 ]
do
    echo  "waiting for $1 to appear"
    sleep 1
done

if [ $# -eq 1 ]
then
    # usage of operstate is not supported since batman2021.0 anymore
    # no need to catch this further, since 'we get batman systemd support soon'
    case $1 in bat*)
        echo "Careful, this is likely not supported anymore."
    esac
    while ! [ "$(cat /sys/class/net/$1/operstate)" = "up" ]
    do
        echo  "waiting for $1 to be up"
        sleep 1
    done
fi
