# ansible configs for freifunkh

## how to use:

``` shell
git clone git@github.com:freifunkh/ansible.git ansible
cd ansible
```

Do not forget to place your secrets.yml into the main dir.

**deploy all supernodes:**
``` shell
ansible-playbook playbooks/supernodes.yml
```

**deploy a single supernode:**

``` shell
ansible-playbook playbooks/supernodes.yml --limit=sn01
```
