# ffh supernodes

## deployment

Ansible does not need any agent on the remotes. The only requirements
on the remote machine are ```ssh``` and ```python2```. On your local
machine you need ansible installed.

1. Add the new host to your ansible hosts config ```/etc/ansible/hosts```.
2. Add the configuration for the new host to ```sn.yml```.
3. Start deployment: ```ansible-playbook sn.yml```
4. Since the new host needs to get access to the remote git, the
   script will pause and wait until you have deployed the generated key
   ```/home/auto/.ssh/id_rsa.pub``` to the git server. When you have
   done this, you should verify that you can access the git. Then you can
   delete the lockfile ```/home/auto/wait_for_access.lock``` and ansible
   should continue with the deployment. If you fail deploying the key properly,
   the git clone command will wait an nearly infinite time for an entered
   password (which will never happen).
5. You should be ready.


## role descriptions

### basic helper roles

- **cli\_tools:** install some cli tools
    - ```netcat-openbsd```
    - ```tcpdump```
- **ssh\_known\_hosts:** install systemwide known_hosts to verify remotes
- **git\_autoupdate:** autoupdate git repositorys
    - provides generic update script for use in cronjobs
        - ```/home/auto/autoupdate.sh <repo-path>```
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

### simple_firewall role

This role offers the common tasks needed in all of our freifunk scenarios. Currently
this only supports IPv4. By default this role only opens port **22/tcp for ssh**. This
can be changed using the ```firewall_ssh_port``` variable. Be careful with this
because you can lock out yourself very easily. The role is very modular and configurable:

**open additional ports:**

    - firewall_open_ports_tcp: [80, 443]
    - firewall_open_ports_udp: [10000]


**allow forwarding for some for some interfaces:**

If you add this to your config, the kernel parameters to activate forwarding will
be set automatically.

    - firewall_allowed_forwards:
      - src_if: bat0
        dest_if: exit-vpn-1
      - src_if: bat0
        dest_if: exit-vpn-2


**nat:**

    - firewall_nat_on_interfaces: ['exit-vpn-1']


**alternative routing tables:**

There is a rather advanced feature of the linux kernel to provide multiple
routing tables on the same host. This is needed on the gateways since the
packets in the freifunk net should get another default route than all other
daemons on the gateway. So we need to manage two routing tables at the same
time.

    - firewall_alternative_routingtables:
      - name: freifunk
        when_packet_from: ["bat0", "internetz-me"]


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
    - host vars: ```fastd_mesh_mac```
    - doesn't work without remotes role

There are two different remotes providers:

- **fastd\_mesh\_remotes\_backbone:** provides access to other supernodes
- **fastd\_mesh\_remotes\_peers\_git:** provide access to peers repo
    - host vars: ```git_addr```
    - installs cronjob to autoupdate peers
