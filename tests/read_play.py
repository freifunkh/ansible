#!/usr/bin/env python3

import sys
import json
import difflib

def parse_result(res, highlighting=None):
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

    if 'diff' not in res:
        result += CYELLOW + 'diff: n/a\n' + CEND + "\n"
        return result

    diffs = []
    if isinstance(res['diff'],list):
        for diff in res['diff']:
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
    elif isinstance(res['diff'], dict):
        diff = res['diff']
        before = diff.get('before', '')
        after = diff.get('after', '')

        if type(before) is not str:
            result += CRED +   '--- BEFORE: ' + str(before) + CEND + "\n"
            result += CGREEN + '+++  AFTER: ' + str(after) + CEND + "\n"
            result += "\n"
            return result

        after = after.splitlines(keepends=True)
        before = before.splitlines(keepends=True)

        if 'before_header' in diff:
            fromfile = diff['before_header']
        else:
            fromfile = '/dev/null'
        if 'after_header' in diff:
            tofile = diff['after_header']
        else:
            tofile = '/dev/null'
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
    else:
        result += CRED + 'Unknown format for diff: ' + type(res['diff']) + CEND + "\n"

    return result

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

    try:
        with open(filename) as f:
            res = json.load(f)
    except json.decoder.JSONDecodeError:
        return ''  # Don't send emails if the JSON is invalid (or None).

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

                if 'results' in host:
                    for res in host['results']:
                        result += parse_result(res, highlighting)
                else:
                    result += parse_result(host, highlighting)

    return (start + result + end).replace('\n', NL)

if __name__ == '__main__':
    print(read_play(sys.argv[1], "terminal"))
