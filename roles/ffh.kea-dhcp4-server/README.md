kea-dhcp4-server
=========

This role sets up an ISC-KEA-Dhcp4 server in the context of a supernode (as in there is BATMAN).

- Installs KEA server via apt from ISC repository
- Creates ramdisk for lease-file
- Configures server for every batman domain / interface
- Updates FERM firewalling
- Extends systemd unitfile to wait for batman devices

Requirements
------------

Assumes a working batman environment. Assumes the usage of ferm for firewalling. __Assumes existing dhcp servers to be non-existing.__

Role Variables
--------------

- `domains`: defaults to `[]`
- `legacy_dom0`: defaults to `true`, controls the handling of `bat0` device
- `dhcp_valid_leasetime`: defaults to `600` seconds
- `dhcp_rebind_timer`: defaults to `300` seconds
- `dhcp_renew_timer`: defaults to `150` seconds
- `dhcp_domain_name`: defaults to `"ffh.zone"`

Dependencies
------------

See requirements.

Example Playbook
----------------

Just add the role to the playbook.

    - hosts: supernodes
      roles:
         - { name: ffh.kea-dhcp4-server, tags: kea-dhcp4-server }

License
-------

MIT

Author Information
------------------

Freifunk Hannover community, https://hannover.freifunk.net/
