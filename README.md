# ffh supernodes

## roles

### dependency tree
```
─┬─ batman ─┬─ fastd_mesh ─┬─ fastd_mesh_remotes_backbone
 |          |              └─ fastd_mesh_remotes_peers_git
 |          └─ dummytap
 └─ cli_tools
```

### overview

- **batman:** provides bat0 interface, sets ips to it
    - host vars: ```ip4_bat0, ip6_bat0```
- **dummytap:** hack to ensure batman has always one interface
  (else bat0 will be destroyed)
- **fastd_mesh:** adds fastd_mesh interface to bat0
    - host vars: ```fastd_mesh_mac, fastd_mesh_secret```
    - doesn't work without remotes role
- **fastd_mesh_remotes_\*:** adds remotes to fastd_mesh
- **cli_tools:**
  - ```netcat-openbsd```
