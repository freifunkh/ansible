#!/usr/bin/env python3

import sys
import json
import difflib

def read_play(filename, highlighting=None):
    result = ''
    NL = '\n'
    start = ''
    end = ''

    if highlighting == 'html':
        CRED = '<span style="color: red;">'
        CGREEN = '<span style="color: green;">'
        CYELLOW = '<span style="color: #d99400;">'
        CEND = '</span>'
        NL = NL
        start = '<html><head></head><body><pre>'
        end = '</pre></body></html>'
    elif highlighting == 'terminal':
        CRED = '\033[31m'
        CGREEN = '\33[32m'
        CYELLOW = '\33[33m'
        CEND = '\033[0m'
    else:
        CRED = ''
        CGREEN = ''
        CYELLOW = ''
        CEND = ''

    with open(filename) as f:
        res = json.load(f)

    for play in res['plays']:
        for task in play['tasks']:
            taskname = task['task']['name']

            for hostname, host in task['hosts'].items():

                if 'failed' in host and host['failed']:
                    result += f"[{hostname}]  {taskname}" + "\n"
                    result += CRED + '############### FAILED ##################' + CEND + "\n"
                    result += host['msg'] + "\n"
                    continue

                if not host['changed']:
                    continue

                result += f"[{hostname}]  {taskname}" + "\n"

                if 'diff' not in host:
                    result += CYELLOW + 'diff: n/a\n' + CEND + "\n"
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
                            result += CRED + line + CEND
                        elif line.startswith('+'):
                            result += CGREEN + line + CEND
                        else:
                            result += line

                    result += "\n"
                elif isinstance(host['diff'], dict):
                    diff = host['diff']
                    before = diff.get('before', '')
                    after = diff.get('after', '')
                    result += CRED +   '--- BEFORE: ' + str(before) + CEND + "\n"
                    result += CGREEN + '+++  AFTER: ' + str(after) + CEND + "\n"
                    result += "\n"
                else:
                    result += CRED + 'Unknown format for diff: ' + type(host['diff']) + CEND + "\n"

    return (start + result + end).replace('\n', NL)

if __name__ == '__main__':
    print(read_play(sys.argv[1], "terminal"))
