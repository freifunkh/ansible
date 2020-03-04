# stats_bash role

This role installs some shell scripts to monitor hosts. They are hosted
[here](https://github.com/freifunkh/prometheus-sn). The statistics are
pushed to a [prometheus pushgateway](https://github.com/prometheus/pushgateway).

**minimal configuration:**

This will export ```uptime```, ```load``` and ```if_stats```.

    - stats_pushgateway:
        host: "[fd12::1002]:9000" # <ip>:<port>
        job: http-server          # job name in prometheus

**ping tests:**

    - stats_pings:
      - host: 8.8.8.8
        name: google-dns
      - host: 8.8.4.4
        name: google-alt-dns

**connected clients of fastd vpn:**

    - stats_fastd_sockets:
      - name: mesh_fastd
        path: /var/run/fastd.mesh_fastd.sock
      - name: admin_vpn
        path: /tmp/fastd.admin.sock

**collect interface statistics using bpfcountd:**

[bpfcountd](https://github.com/lemoer/bpfcountd) is a small daemon counting
packets using libpcap.

    - stats_bpfcountd_interfaces:
      - bat0
      - eth0
