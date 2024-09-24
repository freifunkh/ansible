#!/bin/sh

echo '{"command":"statistic-get-all","arguments":{}}' | nc -U /tmp/kea4-ctrl-socket
