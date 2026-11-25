#!/bin/sh

path="$(dirname "$0")"

# External netbox role not needed anymore, leaving this code as an example
#
#if test -f galaxy/ansible-role-netbox-docker/Makefile; then
#	echo "Skipping to clone ansible-role-netbox-docker since it exists."
#else
#	ansible-galaxy install git+https://github.com/wastrachan/ansible-role-netbox-docker.git -p "$path"/galaxy
#fi
