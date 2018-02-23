#!/bin/sh

rm -f /var/run/node_txtfile/*.prom

for f in /opt/node_exporter/*.sh; do
  bn=$(basename ${f%.sh})
  ${f} > /var/run/node_txtfile/${bn}.prom
done
