# crontab_email role

This role adds a crontab entry in order to set the MAILTO field.
This should result in crontabs output being sent to a useful monitoring email-address.
Call the role multiple times in order to use it with different users.


**basic setting:**

    - user: root      # default: root
    - monitoring_email_address: monitoring@hannover.freifunk.net      # default: monitoring@hannover.freifunk.net
