# yanic_role

[Yanic](https://github.com/FreifunkBremen/yanic)
monitors the freifunk routers in the mesh via multicast.

Example config:

    - yanic_influx_database: yanic_foobar
    - yanic_influx_hostname: http://sn03.s.ffh.zone:8086/
    - yanic_interface: bat0
    - yanic_port: 10002

A password for the database will be generated randomly while
the roles are procesed. The process will stop and ask you to
create the influx database and user, when the password was
generated.


**Generate nodes.json, graph.json, ...:**

    - yanic_nodes_enabled: true
    - yanic_nodes_version: 1
    - yanic_nodes_path: /var/www/harvester.ffh.zone/
