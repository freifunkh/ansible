# ansible configs for freifunkh

## how to use:

``` shell
git clone git@github.com:freifunkh/ansible.git ansible
cd ansible
```

**deploy all supernodes:**
``` shell
ansible-playbook playbooks/supernodes.yml
```

**deploy a single supernode:**

``` shell
ansible-playbook playbooks/supernodes.yml --limit=sn01
```
