# mesh_* roles

These all roles are related in configuring a connection to the rest of the
layer 2 mesh network using ```batman-adv```.

## batman_mesh role

This role simply ensures that the batman kernel module is loaded while booting.
The bat0 device will be created, if the first lower interface is added to
bat0. When exisiting, the bat0 interface also has no ip address configured
by default.

## mesh_fastd role

This role adds a fastd vpn tunnel interface as lower interface into the
bat0 device. By default this role has **no ```peers``` which can connect**,
which can be changed by adding a ```mesh_fastd_remotes_*``` role.
It listens on port 10000 on all all interfaces (```0.0.0.0``` and ```::```) and has a mtu of 1394. You
have to set a mac address on the interface!

    - mesh_fastd_mac: "11:22:33:44:55:66"

**change mtu and port:**

    - mesh_fastd_port: 1337
    - mesh_fastd_mtu: 1234

**change ip to listen on:**

    - mesh_fastd_listen_on:
      - fd::1
      - 192.168.0.1

**change debug level:**

    - mesh_fastd_debug_level: debug2 # default debug level was info

## mesh_fastd_remotes_backbone

This role provides the **hardcoded** public keys of the other supernodes.

## mesh_fastd_remotes_peers_git

This role clones and pulls the public keys of the freifunk routers out of
the peers git from ```git_addr```. It also installs a cronjob that
updates the repository automatically every 5 minutes.
