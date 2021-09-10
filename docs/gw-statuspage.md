# gw-statuspage role

This role sets up [gw-statuspage](https://aiyionpri.me/gw-statuspage/), which provides our supernodes with a gluon like webinterface.

**Dependency**
The program depends on some instance of respondd running on the host.
The role [mesh-announce](./mesh-announce.md) is currently providing that on our machines.

**Configuration**
The program aims not to need configuration, but solely reflects the state of the machine.

Note:

- The program is not fully implemented yet and depends on two python3 scripts, which will be gone eventually
- The role installs aiyions debian repo as apt-source, as well as his gpg-key as apt-key to verify the package

