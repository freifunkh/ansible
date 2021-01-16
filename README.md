# ansible configs for freifunkh

## prerequisites

Ansible v2.7.7 or newer and dnspython are required for operation. Both can be installed using pip3:
```
pip3 install ansible dnspython
```

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

**deploy all supernodes with only a specific role "networkd":**
``` shell
ansible-playbook playbooks/supernodes.yml -t networkd
```

**deploy a single supernode:**

``` shell
ansible-playbook playbooks/supernodes.yml --limit=sn01
```
