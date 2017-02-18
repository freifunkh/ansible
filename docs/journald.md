# journald role

This role installs journald using the ```jessie-backports``` repository,
but also provides some advanced features:

**watch: send mails based on log entries:**

There is no mail sent, when no log message over the specified priority
was happening.

    - journald_watch_enabled: true

The mails are delivered locally using the ```mail``` command. You may
want to consider using the [simple_mail](./simple_mail.md) role.

**watch: change priority or interval**

    - journald_watch_priority: debug # possible values are emerg, alert, crit,
                                       err (default), warning, notice, info, debug

    - journald_watch_interval: 5     # check for messages every */5 minutes
