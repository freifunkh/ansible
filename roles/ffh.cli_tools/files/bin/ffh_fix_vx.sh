#!/bin/sh
for I in `seq 10 23` 99; do
  /usr/local/sbin/batctl meshif bat$I if add vx-$I
done;

for I in 0 `seq 10 23` 99; do
  /usr/local/sbin/batctl meshif bat$I if add vlan-gt-2$I
done;
