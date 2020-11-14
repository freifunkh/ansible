#!/usr/bin/env python3

import sys
import json
import difflib

CRED = '\033[31m'
CGREEN = '\33[32m'
CYELLOW = '\33[33m'
CEND = '\033[0m'

with open(sys.argv[1]) as f:
    res = json.load(f)


for play in res['plays']:
    for task in play['tasks']:
        taskname = task['task']['name']

        for hostname, host in task['hosts'].items():

            if 'failed' in host and host['failed']:
                print(f"[{hostname}]  {taskname}")
                print(CRED + '############### FAILED ##################' + CEND)
                print(host['msg'])
                continue

            if not host['changed']:
                continue

            print(f"[{hostname}]  {taskname}")

            if 'diff' not in host:
                print(CYELLOW + 'diff: n/a\n' + CEND)
                continue

            diffs = []
            if isinstance(host['diff'],list):
                for diff in host['diff']:
                    before = diff.get('before', '')
                    after = diff.get('after', '')

                    after = after.splitlines(keepends=True) 
                    before = before.splitlines(keepends=True)

                    if 'before_header' in diff:
                        fromfile = diff['before_header']
                    else:
                        fromfile = '/dev/null'
                    tofile = diff['after_header']
                    diffs.extend(difflib.unified_diff(before, after,
                        fromfile=fromfile, tofile=tofile))

                for line in diffs:
                    if not line.endswith('\n'):
                        line += '\n'

                    if line.startswith('-'):
                        print(CRED + line + CEND, end='')
                    elif line.startswith('+'):
                        print(CGREEN + line + CEND, end='')
                    else:
                        print(line, end='')

                print()
            elif isinstance(host['diff'], dict):
                diff = host['diff']
                before = diff.get('before', '')
                after = diff.get('after', '')
                print(CRED +   '--- BEFORE: ' + str(before) + CEND)
                print(CGREEN + '+++  AFTER: ' + str(after) + CEND)
                print()
            else:
                print(CRED + 'Unknown format for diff: ' + type(host['diff']) + CEND)







