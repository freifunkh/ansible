#!/usr/bin/env python3

import sys
import json
import difflib
from dateutil.parser import parse as parse_time

CRED = '\033[31m'
CGREEN = '\33[32m'
CYELLOW = '\33[33m'
CEND = '\033[0m'

with open(sys.argv[1]) as f:
    res = json.load(f)

last_taskname = ''
rolename = ''

for play in res['plays']:
    for task in play['tasks']:
        taskname = task['task']['name']
        rolename_new = taskname.split(':')[0].strip()

        if rolename == rolename_new:
            continue

        task_start = parse_time(task['task']['duration']['start'])
        if 'last_start' not in dir():
            last_start = task_start
            rolename = rolename_new
            continue

        t = (task_start - last_start).total_seconds()

        print(f"({t:>10.2f})  {rolename}")

        last_start = task_start
        rolename = rolename_new

t = (task_start - last_start).total_seconds()
print(f"({t:>10.2f})  {rolename}")
