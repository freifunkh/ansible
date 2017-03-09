# ansible roles used in freifunkh

In this repository we store all our roles we have developed for freifunkh.
But some of them may also useful for other projects as well.
To see some examples of our roles in the wild, have a look
at our [ansible-configs](https://github.com/freifunkh/ansible-configs).

## roles

### general useful roles

#### common stuff

- [simple_mail](docs/simple_mail.md) - forwards mails to root into your inbox
- [journald](docs/journald.md) - sends mails to the root account based on the journal
- [admin](docs/admin.md) - authorize people for root access

#### networking

- [dns_recursive](docs/dns_recursive.md) - manage a recursive dns server using unbound
- [dns_authoritative](docs/dns_authoritative.md) - manage an authoritative dns server using nsd4
- [networkd](docs/networkd.md) - manage your network interfaces with networkd
- [dhcp_server](docs/dhcp_server.md) - very basic dhcp server using isc-dhcp-server
- [radv_server](docs/radv_server.md) - very basic radv server using radvd
- [simple_firewall](docs/simple_firewall.md) - configure ip(6)tables for all common cases

#### monitoring

- [grafana](docs/grafana.md) - deploy a grafana server (a statistics dashboard)
- [prometheus](docs/prometheus.md) - deploy a prometheus and maybe the corresponding pushgateway (a statistics collecting daemon)
- [stats_batch](docs/stats_batch.md) - scripts to monitor and push some values to the pushgateway

#### web

- [nginx](docs/nginx.md) - deploy a web server and configure sites

#### other

- cli_tools - common cli tools which are often needed
- git_autoupdate - periodically update a git repository and maybe execute a command after updating

### freifunk only roles

- [gateway_announcement](docs/gateway_announcement.md) - set the batman gw announcement flag based on a ping
- [mesh_*](docs/mesh_*.md) - batman-adv + vpn daemon
- ssh_known_hosts - ssh keys of our infrastructure
- [hopglass-server](docs/hopglass-server.md) - collect data from Freifunk networks
