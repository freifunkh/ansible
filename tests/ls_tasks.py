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

for play in res['plays']:
    for task in play['tasks']:
        taskname = task['task']['name']

        if 'start' in task['task']['duration']:
            task_start = parse_time(task['task']['duration']['start'])
            if 'init' not in dir():
                init = task_start
                last_start = task_start
                last_taskname = taskname
                continue
        else:
            task_start = ''

        t = (task_start - last_start).total_seconds()

        print(f"({t:>10.2f})  {last_taskname}")

        last_start = task_start
        last_taskname = taskname

t = (task_start - last_start).total_seconds()

print(f"({t:>10.2f})  {last_taskname}")
