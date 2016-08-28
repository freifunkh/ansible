#!/bin/bash

cd "$(dirname "$0")"

recipients=(
 -r "0967A8BE30F20FEADD6BB78294F112010ABBDB18" # lemoer
 -r "535952ECAB86CFF2C0559C26B9DE282DF17FE708" # cawi
)

tar -cO secrets | gpg -a ${recipients[@]} -e -o secrets.asc
