# py-respondd role

This role installs py-respondd after cloning it from git.ffh.zone.

py-respondd is mainly written by [descilla](https://github.com/descilla/py-respondd).

It provides a respondd-server meant to run on our gateways in order to make them visible on the map.

We will use the new information to determine the hop distance between a node and his currently chosen gateway.

## dependants

In order for nodesTk to work properly, the nodes.json files must contain the gateways.
As the proposed updater of raute and aiyion relies heavily on nodesTk, updates can not be delivered in correct order unless py-respondd ran at least for a few days in the last three weeks or so.
It's important to run on all supernodes in order not to miss any nodes in the update.

This role should not need any manual interaction while running it.
If it does nevertheless please assign an issue  ~Aiyion
