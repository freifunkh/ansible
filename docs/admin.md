# admin role

This role is helpful to provide access for some people to some hosts via
the root account. There are two different variables for storing the ssh
keys and providing access to the hosts, so you can split them up into
two files.

**add keys:**

    - admin_pubkeys:
      - name: hans
        key: ssh-rsa ...
      - name: susanne
        key: ssh-ed25519 ...

**provide access:**

    - admin_authorized:
      - hans

**Warning:** The role automatically removes all ```admin_pubkeys``` from the host
which are not contained in the ```admin_authorized``` list. So it's very easy to
lock out yourself, if you forget to add your key to the list.
