# nginx role

This role installs the [nginx](http://nginx.org/) HTTP server.

**Simple Site:**

    - nginx_sites:
      - domain: www.site.tld
        root: /var/www/site.tld
      - domain: another-site.tld
        root: /var/www/another-site.tld
      - domain: ...
        root: ...

http://www.site.tld and http://another-site.tld

**Site with SSL (includes without SSL):**

    - nginx_sites:
      - domain: www.site-with-ssl.tld
        root: /var/www/site-with-ssl.tld
        tls: true

https://www.site-with-ssl.tld
(and http://www.site-with-ssl.tld)

**Disable http and only do SSL:**

    - nginx_sites:
      - domain: www.site-with-ssl.tld
        root: /var/www/site-with-ssl.tld
        tls: true
        enable_legacy_http: false

**Reverse proxy:**

    - nginx_sites:
      - domain: www.reverse-proxy.tld
        locations:
          - location: /
            type: proxy
            proxy_forward_url: http://localhost:1234/

http://www.reverse-proxy.tld request is passed to localhost:1234

**Allow directory listing:**

    - nginx_sites:
      - domain: foo.bar.tld
        locations:
          - location: /
            directory_index: true

**Allow cross origin requests:**

    - nginx_sites:
      - domain: foo.bar.tld
        locations:
          - location: /
            allow_cors: true

**Enable gzipping of responses:**

    - nginx_sites:
      - domain: foo.bar.tld
        locations:
          - location: /
            gzip: true

**Site with multiple locations and SSL:**

    - nginx_sites:
      - domain: www.multiple-locations.tld
        root: /var/www/multiple-locations.tld
        tls: true
        locations:
          - location: /stats/
            type: proxy
            proxy_forward_url: http://localhost:3000/
          - location: /hopglass-server/
            type: proxy
            proxy_forward_url: http://127.0.0.1:4000/
          - location: /another-root/
            root: /var/www/another-root
          - location: /download/
            directory_index: true

https://www.multiple-locations.tld using root directory for requests

https://www.multiple-locations.tld/stats/ request is passed to [grafana](grafana.md) (localhost:3000)

https://www.multiple-locations.tld/hopglass-server/ request is passed to hopglass-server (localhost:4000)

https://www.multiple-locations.tld/another-root/ using another root directory for requests

https://www.multiple-locations.tld/download/ directory listing is enabled for this folder

(and without SSL)
