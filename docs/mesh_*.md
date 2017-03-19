# mesh_* roles

These all roles are related in configuring a connection to the rest of the
layer 2 mesh network using ```batman-adv```.

## batman_mesh role

This role simply ensures that the batman kernel module is loaded while booting.
The bat0 device will be created, if the first lower interface is added to
bat0. When exisiting, the bat0 interface also has no ip address configured
by default.

**build batman from source using dkms:**

    - batman_build_from_source: true

**build a custom version of batman:**

    - batman_build_from_source: true
    - batman_build_version: v2016.4   # use a git tag of the batman repo

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

**peer limit:**

    - mesh_fastd_peer_limit: 42    # default is no limit

**soft traffic limit:**
    - mesh_fastd_deny_connections_over_mbit_integer: 40 # this will not let any more connections
                                                        # in, if the outgoing (TX) traffic on eth0
                                                        # is greater than 40 Mbit.

**Warning:** If this option is set, the ```mesh_fastd_peer_limit``` will be ignored because
fastd v17 (which we are currently using) can't use the [```on verify "...";``` option](http://fastd.readthedocs.io/en/v18/releases/v18.html?highlight=on%20verify#more-powerful-peer-groups)
in peer groups. This is first possible in fastd v18.
