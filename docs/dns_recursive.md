# dns_recursive role

Example:

    - dns_recursive_allowed_nets:
      - 10.2.0.0/16
      - fdca:ffee:8::/48
    - dns_recursive_forwards:
      - zone: "."
        to: ["192.168.43.30"]
      - zone: "ffh.zone."
        to: ["fdca:ffee:8::1337"]
    - dns_recursive_allowed_private_adresses:
      - fdca:ffee:8::/48
    - dns_recursive_allowed_private_domains:
      - "ffh.zone."
    - dns_recursive_listen_on:
      - 10.2.30.1
      - fdca:ffee:8::1801
