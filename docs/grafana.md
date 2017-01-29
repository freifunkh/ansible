# grafana role

This role installs the [grafana](http://grafana.org/) monitoring panel software.
This role will generate an **admin password** and put it
in ```/var/lib/ansible/grafana_admin_password``` (only accessible for root).

**use behind reverse proxy:**

    - grafana_root_dir: http://example.com/grafana

**change what grafana listens on:**

    - grafana_listen_on:
        port: 1337    # default was 3000
        ip: 127.0.0.1 # default was any
