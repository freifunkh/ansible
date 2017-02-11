# dns_authorative role

Example:

    - dns_authorative_zones:
        - zone: "services"
          aliases: ["updates.services", "opkg.services", "ntp.services"]
          to: ["fdca:ffee:8::104"]
        - zone: "peng"
          aliases: ["123"]
          to: ["fdca:ffee:8::103"]
    - dns_authorative_nameserver: 
      - nameserver: "sn03.ffh.zone."
      - nameserver: "sn04.ffh.zone."
    - dns_authorative_toplevel:
      - domain: "ffh."
      - domain: "ffh.zone."
    - dns_authorative_listen_on:
      - 10.2.30.1
      - fdca:ffee:8::1801
