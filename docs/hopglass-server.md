# hopglass-server role

The [HopGlass Server](https://github.com/hopglass/hopglass-server) collects data from Freifunk networks and processes it to be used in [HopGlass](https://github.com/plumpudding/hopglass), for statistics and other purposes.

**Default config:**

    hopglass_server_install_dir: /opt/hopglass
    hopglass_server_iface: bat0
    hopglass_server_webserver_ip: 127.0.0.1
    hopglass_server_port: 4000

**Use behind reverse proxy:**

    locations:
        - location: /hopglass-server/
          type: proxy
          proxy_forward_url: http://127.0.0.1:4000/

**Possible webserver queries:**

|Query Location         |Description|
|---------------------- |---|
|/hopglass-server/nodes.json            |HopGlass nodes.json v2|
|/hopglass-server/graph.json            |HopGlass graph.json v1|
|/hopglass-server/metrics               |Prometheus metrics|