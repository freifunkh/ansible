#!/usr/bin/python3

import glob
import json
import socket


def get(fastd_sock_path):
    client = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    client.connect(fastd_sock_path)

    res = bytes()
    while True:
        r = client.recv(1024)
        if not r:
            break
        res += r

    return json.loads(res.decode('utf-8'))

def print_it(name, tags, value):
    print(name, end='')
    print('{', end='')
    kv = []
    for k,v in tags.items():
        kv += [k + '="' + v + '"']
    print(",".join(kv),end="")
    print('} ', end='')
    print(value)

def cross(sp, dev):
    json_res = get(sp)
    peers = json_res['peers'].values()

    peers = filter(lambda p: p['name'].startswith('sn'), peers)

    peers = filter(lambda p: p['connection'] is not None, peers)

    for peer in peers:
        for k,v in peer['connection']['statistics'].items():
            tags = dict(
                peer=peer['name'],
                dev=dev
            )
            print_it('fastd_traffic_' + k + '_bytes', tags, v['bytes'])
            print_it('fastd_traffic_' + k + '_packets', tags, v['packets'])


    print_it('fastd_connected', dict(type="supernode", dev=dev), len(list(peers)))

    # count non supernodes
    peers = json_res['peers'].values()
    peers = filter(lambda p: not p['name'].startswith('sn'), peers)
    peers = filter(lambda p: p['connection'] is not None, peers)

    print_it('fastd_connected', dict(type="other", dev=dev), len(list(peers)))


for sock in glob.glob('/var/run/fastd.*.sock'):
    try:
        cross(sock, sock.replace('/var/run/fastd.', '').replace('.sock', ''))
    except ConnectionRefusedError:
        pass

