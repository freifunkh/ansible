#!/bin/sh

export ANSIBLE_STDOUT_CALLBACK=json
time=$(date -Iseconds)

git fetch --all --quiet
git reset --quiet --hard origin/master

mkdir -p /tmp/auto/dailyrun

for machine in supernodes superexitnodes exitnodes proxmoxes dns ns1 mx1 db tonne harvester vds web rdns buildclouds evergiven dali thetisd rena
do
  ansible-playbook playbooks/${machine}.yml -CD --extra-vars "show_secret_diffs=no" > /tmp/auto/dailyrun/${time}-${machine}.json
  python3 tests/mail.py /tmp/auto/dailyrun/${time}-${machine}.json
done
