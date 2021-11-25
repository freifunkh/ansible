#!/usr/bin/env python3

import datetime
import pytz
import smtplib, ssl
from email.utils import make_msgid
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.header import Header
from email.charset import Charset, QP

import os
import sys
sys.path.insert(0, os.path.dirname(__file__))
from read_play import *

SMTP_HOST = 'mail.ffh.zone'
SMTP_PORT = 25
SMTP_USE_STARTTLS = False
SMTP_FROM = "auto@ruettgers.ffh.zone"
SMTP_REPLY_TO_EMAIL = "monitoring@hannover.freifunk.net"

SMTP_TO = 'monitoring@hannover.freifunk.net'

def send_mail(subject, message, message_html, to):
    msgid = make_msgid()

    msg = MIMEMultipart('alternative')
    msg['Subject'] = str(Header(subject, 'utf-8'))
    msg['From'] = str(Header(SMTP_FROM, 'utf-8'))
    msg['To'] = str(Header(to, 'utf-8'))
    msg['Message-ID'] = msgid
    msg['Reply-To'] = SMTP_REPLY_TO_EMAIL
    msg['Date'] = datetime.datetime.now(pytz.utc).strftime("%a, %e %b %Y %T %z")

    # add message
    charset = Charset('utf-8')
    # QP = quoted printable; this is better readable instead of base64, when
    # the mail is read in plaintext!
    charset.body_encoding = QP

    message_part = MIMEText(message.encode('utf-8'), 'plain', charset)
    msg.attach(message_part)

    message_part2 = MIMEText(message_html.encode('utf-8'), 'html', charset)
    msg.attach(message_part2)

    with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
        server.ehlo()
        if SMTP_USE_STARTTLS:
            context = ssl.create_default_context()
            server.starttls(context=context)

        server.sendmail(SMTP_FROM, to, msg.as_string())

if __name__ == '__main__':
    filename = sys.argv[1]

    msg_txt = read_play(filename)
    msg_html = read_play(filename, 'html')

    if msg_txt:
        send_mail('Daily Report of Ansible Run', msg_txt, msg_html, SMTP_TO)
