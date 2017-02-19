# dhcp_server role

Example:

    - dhcp_interfaces: [bat0]
    - dhcp_range:
        from: 10.2.30.2
        to: 10.2.39.254
    - dhcp_options:
        gateway: 10.2.30.1
        dns_server: 10.2.30.1
