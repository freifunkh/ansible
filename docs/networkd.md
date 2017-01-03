# networkd role

We use systemd-networkd instead of debians own network scripts. Systemd provides
much more reliable way to configure interfaces, even if they are disappearing
now and then. **All further network modules are depending on this.** Since
networkd also handles the uplink connection of the server, some variables are
introduced to do this.

- **networkd:** replaces debian networking with systemd-networkd
    - host_vars: ```networkd_uplink.interface, networkd_uplink.networks, networkd_uplink.dns```
    - creates a configuration for the uplink interface

**gre tunnel:**

    - networkd_gre_tunnels:
      - name: internetz-me
        lower_interface: eth0
        remote_outer_ip: 178.32.215.75
        local_outer_ip: 138.201.220.61
        local_inner_addr:
          - 192.168.43.31/31

Note: It is possible to use multiple gre tunnels.
Note: If you use the ```simple_firewall``` role, it will automatically configure
      a rule to allow incomming gre traffic for the ```remote_outer_ip```.
