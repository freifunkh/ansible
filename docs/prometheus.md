# prometheus role

Downloads [prometheus](https://prometheus.io/) from github and configures it
in ```/etc/prometheus.yml``` with datadir ```/var/lib/prometheus/```.

Simple config:

    - prometheus_scrapes:
        - name: prometheus
          targets: ['localhost:9090', ...]
        - name: ha_cluster
          ...

With non default intervals:

    - prometheus_scrapes:
        - name: special
          interval: 120 # default was 60 seconds
          timeout: 15   # default was 10 seconds
          targets: ['example.com:1337']

Another version:

    - prometheus_version: 1.4.1  # default
