# ansible configs for freifunkh

## how to use:

``` shell
git clone git@github.com:freifunkh/ansible.git ansible
cd ansible
```

Obtain the **.vaultpassphrase** from someone in the core team and place it into the main directory.

**deploy all supernodes:**
``` shell
ansible-playbook playbooks/supernodes.yml
```

**deploy a single supernode:**

``` shell
ansible-playbook playbooks/supernodes.yml --limit=sn01
```
