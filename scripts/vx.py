#!/usr/bin/env python3
from hashlib import md5
from hashlib import sha256
from sys import argv

# implemented like in
# https://github.com/freifunk-gluon/gluon/blob/7709de6753bf6a8e96d17257882c3fdc3c3bc76b/package/gluon-core/luasrc/usr/lib/lua/gluon/util.lua

# We use this to generate vxlan ids for groupvars/all.yml around line 102 for 'domains:'.

def md5sum(something):
    return md5(something.encode('utf-8')).hexdigest()

def ds_bytes(key, length, seed):
    ret=""
    v=""
    i=0

    while len(ret) < 2*length:
        i+=1
        v=md5sum("{}{}{}{}".format(v, key, seed.lower(), i))
        ret+=v
    return ret[0: 2*length]

def vxlanid(domain_name):
    sha=sha256(domain_name.encode('utf-8')).hexdigest()
    return int(ds_bytes("gluon-mesh-vxlan", 3, sha), 16)

if "__main__" == __name__:
    argc=len(argv)

    if 2!=argc:
        print("usage: {} <domain-name>".format(argv[0]))
        exit(1)

    print(vxlanid(argv[1]))
