# gatemon role

This role clones the hannoveran fork of Gatemon and deploys a probe.

**monimal configuration:**
    - gatemon_name: <name>
    - gatemon_provider: <provider>
    - gatemon_token: <token>

**optional configuration:**
    - gatemon_device: defaults to bat0
    - gatemon_fetchhost: defaults to meineip.moritzrudert.de
    - gatemon_api_url: defaults to https://status.ffh.zone/put.php

Note:

- In order to test v4 addresses gatemon binds to the dhcp port. If this is already in use, it fails.
