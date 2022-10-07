#!/usr/bin/python3
# -*- coding: utf-8 -*-
import curses
import time
import linecache
import os
import re
import sys


def get_iface_type(iface):
    syspath = '/sys/class/net/' + iface

    # strategy 1: use /sys/class/net/IFACE/uevent
    with open(syspath + '/uevent') as f:
        uevent = f.read()
        regex = r"DEVTYPE=(.*)"
        match = re.match(regex, uevent)
        if match is not None:
            return match.group(1)

    # strategy 2: check if certain subfolders in /sys/class/net/IFACE/ exist
    types_with_subfolders = ['mesh', 'bridge']

    for t in types_with_subfolders:
        if os.path.exists(syspath + '/' + t):
            return t

    # strategy 3: substrings in interface name
    types_with_substrings = ['fastd', 'gre', 'gt']

    for t in types_with_substrings:
        if t in iface:
            return t

    # strategy 4: return unknown
    return "unknown"


def readstat(iface, stat):
    with open('/sys/class/net/' + iface + '/statistics/' + stat) as f:
        return f.read()

def format_si(val, unit, force=None):
    units = {
        'G': 1024**3,
        'M': 1024**2,
        'k': 1024**1,
        ' ': -1
    }

    if force is not None:
        return str(int(val/abs(1024**2))) + ' M' + unit

    for u, v in units.items():
        if abs(val) > v:
            return str(int(val/abs(v))) + ' ' + u + unit

class ifstats:

    ALL_STATS = {
        "rx_bytes": dict(factor=8, suffix="bit"),
        "tx_bytes": dict(factor=8, suffix="bit"),
        "rx_packets": dict(suffix="pkt"),
        "tx_packets": dict(suffix="pkt")
    }

    def __init__(self, iface):
        self.iface = iface
        self.stats = {}
        self.old_stats = {}
        self.old_timestamp = None
        self.timestamp = None
        self.type = get_iface_type(iface)

    def maybe_update_by_interval(self, delta_seconds):
        if self.timestamp is None or time.time() - self.timestamp > delta_seconds:
            self.update()

    def update(self):
        self.old_stats = self.stats
        self.stats = {}
        self.old_timestamp = self.timestamp
        self.timestamp = time.time()

        for s in ifstats.ALL_STATS.keys():
            self.stats[s] = int(readstat(self.iface, s))

    def get_current_diff_str(self, stat):
        if self.old_timestamp is None:
            return "n/a yet"

        meta = ifstats.ALL_STATS[stat]
        return format_si(self.get_current_diff(stat), meta.get('suffix') + '/s', force=True)

    def get_current_diff(self, stat):
        if self.old_timestamp is None:
            return None

        delta_val = self.stats[stat] - self.old_stats[stat]
        delta_t = self.timestamp - self.old_timestamp

        meta = ifstats.ALL_STATS[stat]

        factor = meta.get('factor', 1)

        return factor * delta_val / delta_t


def init_curses():
    stdscr = curses.initscr()
    curses.noecho()
    curses.cbreak()
    stdscr.keypad(1)
    curses.start_color()
    curses.init_pair(1, curses.COLOR_GREEN, curses.COLOR_BLUE)
    curses.init_pair(2, curses.COLOR_YELLOW, curses.COLOR_BLACK)
    stdscr.bkgd(curses.color_pair(1))
    stdscr.refresh()
    return stdscr

def show_menu(win, iftypes, active):
    win.clear()
    win.bkgd(curses.color_pair(2))
    win.box()

    win.move(1, 2)
    i = 1
    for t in iftypes:
        win.addstr("F" + str(i) + ":", curses.A_BOLD)
        win.addstr(' ')
        win.addstr(t, curses.A_UNDERLINE if active == t else 0)
        win.addstr('  ')
        i += 1

    win.addstr('x:', curses.A_BOLD)
    win.addstr(' exit')


    win.refresh()

def table_cols(*kargs):
    fmt_str = ""
    for k in kargs:
        fmt_str += "{:>" + str(k) + "}"
    return fmt_str

def read_file(menu_win, iftype):
    # menu_win.clear()
    # menu_win.box()
    # menu_win.addstr(1, 2, "x:", curses.A_UNDERLINE)
    # menu_win.addstr(1, 5, "Ende ->")
    # menu_win.addstr(1, 14, iftype)
    # menu_win.refresh()
    file_win = curses.newwin(80, 90, 4, 0)
    file_win.box()
    line_start = 1
    line_max = 25
    i = 0
    stdscr.timeout(1000)
    while True:
        file_win.erase()
        file_win.box()

        line_no = 2

        f = table_cols(27, 15, 15)

        file_win.addstr(line_no, 2, f.format('IFACE', 'RX', 'TX'))
        line_no += 1

        file_win.addstr(line_no, 2, '')
        line_no += 1

        rx_total = 0
        tx_total = 0

        for ifstats_obj in ifstats_objs:
            if ifstats_obj.type != iftype:
                continue

            line = f.format(
                    ifstats_obj.iface,
                    ifstats_obj.get_current_diff_str('rx_bytes'),
                    ifstats_obj.get_current_diff_str('tx_bytes')
            )
            file_win.addstr(line_no, 2, line)
            line_no += 1

            rx_total += ifstats_obj.get_current_diff('rx_bytes') or 0
            tx_total += ifstats_obj.get_current_diff('tx_bytes') or 0

        line_no += 1
        line = f.format(
                'TOTAL',
                format_si(rx_total, 'bit/s', force=True),
                format_si(tx_total, 'bit/s', force=True),
        )
        file_win.addstr(line_no, 2, line)

        for ifstats_obj in ifstats_objs:
            ifstats_obj.maybe_update_by_interval(1)

        i += 1

        file_win.refresh()
        c = stdscr.getch()
        if c == ord('x'):
            return None
        elif c in range(curses.KEY_F1, curses.KEY_F13):
            return c - curses.KEY_F1
        elif c == curses.KEY_UP:
            if line_start > 1:
                line_start -= 1
        elif c == curses.KEY_DOWN:
            line_start += 1

if False:
    interfaces = ["enp0s25", "wlp3s0"]

    ifstats_objs = []

    for i in interfaces:
        ifstats_objs.append(ifstats(i))

    while True:
        time.sleep(0.1)

        try:
            import pprint
            pprint.pprint([ifstats_objs[1].stats['rx_bytes']-ifstats_objs[1].old_stats['rx_bytes']])
        except:
            print('IGN')

        for ifstats_obj in ifstats_objs:
            ifstats_obj.maybe_update_by_interval(1)



if True:
    #interfaces = ["enp0s25", "wlp3s0"]

    import glob
    ifpaths = glob.glob('/sys/class/net/*')
    interfaces = [ifpath.split('/')[-1] for ifpath in ifpaths]
    interfaces.sort()

    ifstats_objs = []
    iftypes = []
    iftypes.sort()

    for i in interfaces:
        io = ifstats(i)
        ifstats_objs.append(io)

        if io.type not in iftypes:
            iftypes.append(io.type)


    stdscr = init_curses()
    mwin = curses.newwin(3, 90, 0, 0)

    offset = 0
    try:
        while True:
            stdscr.erase()
            stdscr.refresh()

            show_menu(mwin, iftypes, active=iftypes[offset])
            new_offset = read_file(mwin, iftypes[offset])

            if new_offset is None:
                break

            if new_offset < len(iftypes):
                offset = new_offset
    except Exception as e:
        curses.nocbreak()
        stdscr.keypad(0)
        curses.echo()
        curses.endwin()
        raise e
    except KeyboardInterrupt:
        pass

    curses.nocbreak()
    stdscr.keypad(0)
    curses.echo()
    curses.endwin()
