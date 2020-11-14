#!/bin/sh

set -e

DIR=$(dirname "$0")

mkdir -p "$DIR"/tmp

cd "$DIR"/..

export ANSIBLE_STDOUT_CALLBACK=json

time=$(date -Iseconds)

ansible-playbook playbooks/supernodes.yml -CD > tests/tmp/${time}.json
