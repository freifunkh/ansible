# cron-apt role

This role install cron-apt, which runs "apt upgrade" on security updates
every day at 4am. It mails a report, if anything was installed.

**add keys:**

    - cron_apt_mailto: some@email.address
