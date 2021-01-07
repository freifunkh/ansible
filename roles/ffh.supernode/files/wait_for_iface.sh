#!/bin/sh
LOCKFILE=/tmp/wait_for_iface.lock
FAILFILE=/tmp/wait_for_iface.fail
LOCKCMD="set -o noclobber ; \"${LOCKFILE}\" 2> /dev/null"
FAILCMD="set -o noclobber ; \"${FAILFILE}\" 2> /dev/null"
TIMEOUT=600
GUARDINTERVAL=5
FAILSTATE=0

while ! [ -d /sys/class/net/$1 ]
do
    echo  "waiting for $1 to appear"
    sleep 1
done

if [ $# -eq 1 ]
then
    while ! [ "$(cat /sys/class/net/$1/operstate)" = "up" ]
    do
        echo  "waiting for $1 to be up"
        sleep 1
    done
fi

# serialize up to TIMEOUT/GUARDINTERVAL jobs 
i=0
until (eval ${LOCKCMD})
do
    if [ $i -eq $TIMEOUT ] && (eval ${FAILCMD})
    then
        break
    fi
    ((i++))
done

# sleep some time to wait for the previous caller to finish
sleep $GUARDINTERVAL

# don't forget to delete the lockfiles
rm -f "${LOCKFILE}"
rm -f "${FAILFILE}"
