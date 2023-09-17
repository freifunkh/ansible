#!/bin/bash

cleanup() {
	git am --abort
	git reset --hard origin/main
	>&2 echo "Warning: git am of $file failed"
	>&2 echo "git am --abort has already been executed"
	>&2 echo "as well as 'git reset --hard origin/main'"
	>&2 echo "to reset manually, remove the patches directory'"
	exit 1
}
trap 'cleanup' ERR

for file in patches/* ; do
	git am $file
done
