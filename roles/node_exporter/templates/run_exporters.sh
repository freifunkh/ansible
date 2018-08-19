#!/bin/sh

for f in /opt/node_exporter/*; do
  bn=$(basename ${f%.sh})
  ${f} > /var/run/node_txtfile/${bn}.tmp
  mv /var/run/node_txtfile/${bn}.tmp /var/run/node_txtfile/${bn}.prom
done
