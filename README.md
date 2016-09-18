# ffh supernodes

## role descriptions

### basic helper roles

- **cli\_tools:** install some cli tools
    - ```netcat-openbsd```
    - ```tcpdump```
- **ssh\_known\_hosts:** install systemwide known_hosts to verify remotes
- **git\_autoupdate:** autoupdate git repositorys
    - provides generic update script for use in cronjobs
        - exit status indicates whether the repo has changed
    - cronjobs should run as user: ```auto```

### networking roles

We use systemd-networkd instead of debians own network scripts. Systemd provides
much more reliable way to configure interfaces, even if they are disappearing
now and then. **All further network modules are depending on this.** Since
networkd also handles the uplink connection of the server, some variables are
introduced to do this.

- **networkd:** replaces debian networking with systemd-networkd
    - host_vars: ```networkd_uplink.interface, networkd_uplink.networks, networkd_uplink.dns```
    - creates a configuration for the uplink interface

### mesh networking roles

The basic functionality is provided by the batman role. It handles the proper
configuration of the bat0 interface. But the interface is only created, if
we have at least one "mesh provider".

- **batman:** provides bat0 interface, sets ips to it
    - host vars: ```ip4_bat0, ip6_bat0```
    - interface is not created without mesh provider

The only existing provider is fastd_mesh at the moment. This role creates a
fastd instance and binds it to batman. But it does not accept a connection
from any peer until you add at lease one "remotes provider".

- **fastd\_mesh:** adds fastd_mesh interface to bat0
    - host vars: ```fastd_mesh_mac, fastd_mesh_secret```
    - doesn't work without remotes role

There are two different remotes providers:

- **fastd\_mesh\_remotes\_backbone:** provides access to other supernodes
- **fastd\_mesh\_remotes\_peers\_git:** provide access to peers repo
    - host vars: ```git_addr```
    - installs cronjob to autoupdate peers
