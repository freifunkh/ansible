#!/usr/bin/python

import re
import sys
import json
import subprocess


def get_nvme_list():
    stdraw = subprocess.check_output("sudo nvme list | grep '/dev/' | awk '{print $1}'", shell=True)
    stdout = stdraw.decode()

    for i in stdout.strip().split():
        data_list = [{"{#NVMENAME}": i} for i in stdout.strip().split()]

    print(json.dumps(data_list))


def get_nvme_health(disk_name):
    nvme_health = subprocess.check_output("sudo nvme smart-log {} | grep 'percentage_used\s*:'".format(disk_name), shell=True)
    output = nvme_health.decode('ascii').strip()
    print(re.findall(r'\d+', output)[-1])


if sys.argv[1] == 'nvme_list':
    get_nvme_list()
else:
    get_nvme_health(sys.argv[1])
