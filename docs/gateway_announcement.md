# gateway_announcement role

The server mode in batman controls whether this node gets broadcast dhcp
requests sent to. This role activates and deactivates the server mode in
```batman-adv``` based on a ping test every one minute. Furthermore it
activates or deactivates the dhcp server to prevent renewals of existing
leases.
