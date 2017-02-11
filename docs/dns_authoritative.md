# dns_authoritative role

Example:

    - dns_authoritative_zones:
        - zone: "services"
          aliases: ["updates.services", "opkg.services", "ntp.services"]
          to: ["fdca:ffee:8::104"]
        - zone: "peng"
          aliases: ["123"]
          to: ["fdca:ffee:8::103"]
    - dns_authoritative_nameserver: 
      - nameserver: "sn03.ffh.zone."
      - nameserver: "sn04.ffh.zone."
    - dns_authoritative_toplevel:
      - domain: "ffh."
      - domain: "ffh.zone."
    - dns_authoritative_listen_on:
      - 10.2.30.1
      - fdca:ffee:8::1801
