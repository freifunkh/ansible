#!/bin/sh

metric_name=$1
file=$2

if [ -f "$file" ]; then
	echo "$metric_name" $(cat $file)
fi
