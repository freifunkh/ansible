# simple_firewall role

This role offers the common tasks needed in all of our freifunk scenarios.
By default this role only opens port **22/tcp for ssh**. This
can be changed using the ```firewall_ssh_port``` variable. Be careful with this
because you can lock out yourself very easily. The role is very modular and configurable:

**open additional ports:**

    - firewall_open_ports_tcp: [80, 443]
    - firewall_open_ports_udp: [10000]


**allow forwarding for some for some interfaces:**

If you add this to your config, the kernel parameters to activate forwarding will
be set automatically. This will permit forwarding in both directions.

    - firewall_allowed_forwards:
      - between: bat0
        and: exit-vpn-1
      - between: bat0
        and: exit-vpn-2


**nat:**

    - firewall_nat4_on_interfaces: ['exit-vpn-1']


**alternative routing tables:**

There is a rather advanced feature of the linux kernel to provide multiple
routing tables on the same host. This is needed on the gateways since the
packets in the freifunk net should get another default route than all other
daemons on the gateway. So we need to manage two routing tables at the same
time.

    - firewall_alternative_routingtables:
      - name: freifunk
        when_packet_from: ["bat0", "internetz-me"]
        routes:
          - dest_net: default
            dest_if: internetz-me
            via: 192.168.43.30
          - dest_net: 10.2.0.0/16
            dest_if: bat0
          - dest_net: fdca:ffee:8::/64
            dest_if: bat0

**gre tunnels:**

If you use the networkd role to define your gre tunnels, the simple_firewall will
automatically add a rule to allow incomming gre traffic from the ```remote_outer_ip```.
