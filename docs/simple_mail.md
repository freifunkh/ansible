# simple_mail role

This mail uses ssmtp to send mails which are addressed to the
root user on the local system to an external smtp server.

**example:**

    - simple_mail:
        root_email: monitoring@hannover.freifunk.net
        mail_server: hannover.freifunk.net

**Warning:** The ```simple_mail.mail_server``` variable
does not use the ```MX```-Record, so you need to specify
the mailserver directly.
