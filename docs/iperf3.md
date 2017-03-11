# iperf3

This role install iperf3 binaries and runs an iperf3 server. The 
server binds to every device on port 5201/tcp.

Please use the firewall to limit access.

This role adds a user "iperf" to the system and runs the binary
in that user context.

A systemd unitfile is used to run the service at startup.
