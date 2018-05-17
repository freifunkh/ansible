# ansible roles used in freifunkh

In this repository we store all our roles we have developed for freifunkh.
But some of them may also useful for other projects as well.
To see some examples of our roles in the wild, have a look
at our [ansible-configs](https://github.com/freifunkh/ansible-configs).

## roles

### general useful roles

#### common stuff

- [simple_mail](docs/simple_mail.md) - forwards mails to root into your inbox using ssmtpd
- [postfix](docs/postfix.md) - minimal Postfix setup
- [journald](docs/journald.md) - sends mails to the root account based on the journal
- [admin](docs/admin.md) - authorize people for root access
- [cron-apt](docs/cron-apt.md) - installs debian security updates on a daily basis
- [cli_tools](docs/cli_tools.md) - common cli tools which are often needed

#### networking

- [babeld](docs/babeld.md) - babeld routing daemon
- [dns_recursive](docs/dns_recursive.md) - manage a recursive dns server using unbound
- [dns_authoritative](docs/dns_authoritative.md) - manage an authoritative dns server using nsd4
- [networkd](docs/networkd.md) - manage your network interfaces with networkd
- [dhcp_server](docs/dhcp_server.md) - very basic dhcp server using isc-dhcp-server
- [radv_server](docs/radv_server.md) - very basic radv server using radvd
- [ferm](docs/ferm.md) - Firewalling (superseding simple_firewall role)
- [ntp](docs/ntp.md) - simple ntp daemon

#### monitoring

- [grafana](docs/grafana.md) - deploy a grafana server (a statistics dashboard)
- [prometheus](docs/prometheus.md) - deploy a prometheus and maybe the corresponding pushgateway (a statistics collecting daemon)
- [yanic](docs/yanic.md) - [Yanic](https://github.com/FreifunkBremen/yanic) queries the freifunk routers using the respondd multicast protocol for information
- [mesh_announce](docs/mesh_announce.md) - respondd client (supersedes py-respondd)
- [node_exporter](docs/node_exporter.md) - node_exporter
- [iperf3](docs/iperf3.md) - iperf3 server

#### web

- [nginx](docs/nginx.md) - deploy a web server and configure sites
- [foswiki](docs/foswiki.md) - deploy a foswiki installation

### freifunk only roles

- [supernode](docs/supernode.md) - basic settings for supernodes
- [exitnode](docs/exitnode.md) - basic settings for exitnodes
- [gateway_announcement](docs/gateway_announcement.md) - set the batman gw announcement flag based on a ping
- [mesh...](docs/mesh_*.md) - batman-adv + vpn daemon
- [git_autoupdate](docs/git_autoupdate.md) - periodically update a git repository and maybe execute a command after updating

### kinda deprecated
- [simple_firewall](docs/simple_firewall.md) - configure ip(6)tables for all common cases
- [py-respondd](docs/py-respondd.md) - very basic respondd server (results in gateways beeing shown in the map)
- [gatemon](docs/gatemon.md) - deploy a [gatemon](https://github.com/freifunkh/gatemon) probe
- [stats_batch](docs/stats_batch.md) - scripts to monitor and push some values to the pushgateway

