#!/usr/bin/env python3
from argparse import ArgumentParser as ArgParser
from datetime import datetime, timedelta
from json import dumps as json_dumps
from os import path
from pyroute2 import WireGuard

TIMEOUT = timedelta(minutes=3)


def get_stats(format, interface, extended=True):
    infos = WireGuard().info(interface)

    peers = []
    combined = { "interface": interface }
    established_peers_count = 0

    for info in infos:
        try:
            # we fail continue here, if this atribute does not exist...
            info.WGDEVICE_A_PEERS
        except:
            continue

        clients = info.WGDEVICE_A_PEERS.value

        for client in clients:
            public_key = client.WGPEER_A_PUBLIC_KEY["value"].decode("utf-8")

            # ignore dummy key
            if public_key == (43 * "0" + "="):
                continue

            established = False
            latest_handshake = client.WGPEER_A_LAST_HANDSHAKE_TIME.get("tv_sec")

            if latest_handshake and datetime.now() - datetime.fromtimestamp(latest_handshake) < TIMEOUT:
                established = True
                established_peers_count += 1

            if extended:
                peers.append({
                    "public_key": public_key,
                    "latest_handshake": latest_handshake,
                    "is_established": established,
                    "rx_bytes": int(client.WGPEER_A_RX_BYTES['value']),
                    "tx_bytes": int(client.WGPEER_A_TX_BYTES['value']),
                })

    if extended:
        combined["peers"] = peers

    combined["established_peers_count"] = established_peers_count

    return combined


def print_influx_format(stats):
    timestamp = str(round(datetime.now().timestamp())) + "0" * 9

    print("wireguard_device" +
          ",name=" + stats['interface'] +
          ",type=linux_kernel " +
          "established_peers=" + str(stats['established_peers_count']) +
          "i " + timestamp)

    if 'peers' not in stats:
        return

    for peer in stats['peers']:
        print("wireguard_peer,device=" + stats['interface'] +
              ",public_key=" + peer['public_key'] +
              " last_handshake=" + str(peer['latest_handshake']) +
              "i,rx_bytes=" + str(peer['rx_bytes']) +
              "i,tx_bytes=" + str(peer['tx_bytes']) +
              "i " + timestamp)


def check_iface_type(iface, type):
    if not path.exists(f'/sys/class/net/{iface}'):
        print(f'Iface {iface} does not exist! Exiting...')
        exit(1)

    with open(f'/sys/class/net/{iface}/uevent', 'r') as f:
        for line in f.readlines():
            device_tuple = line.replace('\n', '').split('=')
            if device_tuple[0] == 'DEVTYPE' and device_tuple[1] != type:
                print(f'Iface {iface} is wrong type! Should be {type},\
                        but is {device_tuple[1]}. Exiting...')
                exit(1)


if __name__ == '__main__':
    parser = ArgParser(description='Dump statistics of WireGuard interfaces')
    parser.add_argument('-f', '--format', metavar='FORMAT', type=str,
                        help='allowed formats are: "json", "influx"')
    parser.add_argument('-i', '--interface', metavar='IFACE', type=str,
                        help='the WireGuard interfaces', default=[], nargs='+')
    parser.add_argument('-e', '--extended', action='store_true',
                        help='show extended information about each node')
    args = parser.parse_args()

    if len(args.interface) == 0:
        print('Error: You need to specify at least one WireGuard interface.')
        exit(1)

    iface_stats = []
    for i in range(len(args.interface)):
        check_iface_type(args.interface[i], 'wireguard')
        iface_stats.append(get_stats(args.format, args.interface[i],
                                     extended=args.extended))

    if args.format == "influx":
        for stats in iface_stats:
            print_influx_format(stats)
    else:
        print(json_dumps(iface_stats))
