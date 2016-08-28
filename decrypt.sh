#!/bin/bash

cd "$(dirname "$0")"

gpg -d secrets.asc | tar -x
