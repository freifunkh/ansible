#!/bin/sh

export ANSIBLE_STDOUT_CALLBACK=json
time=$(date -Iseconds)

git fetch --all --quiet
git reset --quiet --hard origin/master

mkdir -p /tmp/auto/dailyrun

ansible-playbook playbooks/supernodes.yml -CD --extra-vars "show_secret_diffs=no" > /tmp/auto/dailyrun/${time}.json
python3 tests/mail.py /tmp/auto/dailyrun/${time}.json
