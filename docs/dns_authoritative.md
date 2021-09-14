# dns_authoritative role

This module is tightly integrated with dns_zonenodes. dns_zonenodes is responsible for handling the SOA serial numbers of this role,
and the reverse-dns hostnames for this module are also set by dns_zonenodes. 

Example:
```
    - dns_authoritative_nameserver: 
      - nameserver: "ansibletest.tbspace.de."
      - nameserver: "ns2.he.net."
      - nameserver: "ns3.he.net."
    - dns_authoritative_allowAXFR: 
      - nameserver: "2001:470:600::2"
    - dns_authoritative_notify: 
      - nameserver: "2001:470:100::2"
    - dns_authoritative_toplevel:
      - domain: "ffh.zone."
    - dns_authoritative_listen_on:
      - "127.0.0.1"
      - "::1"
      - "2a01:4f8:171:2bec:0:42:dead:beef"
    - dns_authoritative_external:
      - domain: "n.ffh.zone"
        zonefile: "n.ffh.zone.zone"
      - domain: "8.0.0.0.e.e.f.f.a.c.d.f.ip6.arpa"
        zonefile: "8.0.0.0.e.e.f.f.a.c.d.f.ip6.arpa.zone"
    - dns_authoritative_zones:
        - zone: "services"
          aliases: ["updates.services", "opkg.services", "ntp.services"]
          to: "fdca:ffee:8::104"
        - zone: "peng"
          aliases: ["123"]
          to: "fdca:ffee:8::103"
```

dns_zonenodes can be configured as follows: 
```
    - dns_zonenodes_toplevel: "ffh.zone."
    - dns_zonenodes_nodedomain: "n.ffh.zone"
    - dns_zonenodes_rdnsdomain: "8.0.0.0.e.e.f.f.a.c.d.f.ip6.arpa"
    - dns_zonenodes_matchIP: "/^fdca/"
    - dns_zonenodes_nodeurl: "https://harvester.ffh.zone/api/nodes.json"
```
the _toplevel variable sets the domain, which is automatically suffixed to every hostname in the 
dns_authoritative_zones variable to create a correct PTR/rDNS-record.

_matchIP configures a regex which is used to determine which IPv6-address of these found in the router 
is used for forward resolution of the nodedomain (in this case n.ffh.zone) address. 