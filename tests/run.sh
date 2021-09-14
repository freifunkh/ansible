#!/bin/sh

set -e

DIR=$(dirname "$0")

mkdir -p "$DIR"/tmp

cd "$DIR"/..

export ANSIBLE_STDOUT_CALLBACK=json

time=$(date -Iseconds)

ansible-playbook playbooks/supernodes.yml -CD --extra-vars "show_secret_diffs=no" > tests/tmp/${time}.json
