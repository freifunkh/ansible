Traefik
=========

Traefik Reverse Proxy.

Howto use it
----------------

Do the following things to your container to expose it via Traefik to the outside world (incl. handlings of ssl certs):

- put it into an (externally created) networkd called 'proxy'
- set the following lables:
```
traefik.enable: "true"
traefik.docker.network: "proxy" # mucho importante
traefik.http.routers.mycontainer-https.entrypoints: "websecure"
traefik.http.routers.mycontainer-https.rule: "Host(`mycontainer.ffh.zone`)"
traefik.http.routers.mycontainer-https.tls.certresolver: "letsencrypt"
traefik.http.routers.mycontainer-https.service: "mycontainer-https"
traefik.http.services.mycontainer-https.loadbalancer.server.port: "3000"
```
(replace `mycontainer` with the name of your container, replace `3000` with the port, your container exposes)
- set the exposes and networks in your docker-compose file to something like this
```
services:
  mycontainer:
    expose:
      - "3000"
    networks:
      - "proxy"

...

networks:
  proxy:
    name: proxy
    external: true
```
- optionally set the following labels:
```
traefik.http.routers.mycontainer-http.entrypoints: "web"
traefik.http.routers.mycontainer-http.rule: "Host(`mycontainer.ffh.zone`)"
traefik.http.routers.mycontainer-http.middlewares: "mycontainer"
traefik.http.middlewares.mycontainer.redirectscheme.scheme: "https"
```
- `proxy`, `web` and `websecure` are hardcoded intro _our_ Traefik instance and are not negotiable
