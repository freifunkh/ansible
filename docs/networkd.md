# networkd role

We use systemd-networkd instead of debians own network scripts. Systemd provides
much more reliable way to configure interfaces, even if they are disappearing
now and then. **All further network modules are depending on this.** Since
networkd also handles the uplink connection of the server, some variables are
introduced to do this.

**dhcp configuration:**
    - networkd_configures:
      - iface: eth0
        dhcp: true

**very simple iface configuration:**

    - networkd_configures
      - iface: bat0
        adresses:
          - 192.168.43.31/31
          - fdca::1/64
      - iface: ...

**uplink iface configuration:**

    - networkd_configures:
      - iface: eth0
        addresses:
          - 138.201.220.61/26
        gateway4: 138.201.220.1
        gateway6: fe80::1
        dns_server: [213.133.98.98]
      - iface: ...


**gre tunnel:**

    - networkd_gre_tunnels:
      - name: internetz-me
        lower_interface: eth0
        remote_outer_ip: 178.32.215.75
        local_outer_ip: 138.201.220.61
      - name: ...

**tap device:**

    - networkd_tap_devices:
      - mesh_fastd
      - foobar


Note:

- It is possible to use multiple gre tunnels.
- This will only configure a raw gre tunnel without any assigned ip adresses.
  You need to configure addresses seperate in ```networkd_configures```.
