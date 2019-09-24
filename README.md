# ansible config for freifunkh

## how to use:

**suggested directory layout:**

    --- inventory/
    |   \-- ff
    |
    |-- roles/
    |   |-- ff/
    |   |   |-- docs/
    |   |   |   \-- ...
    |   |   \-- roles/
    |   |       |-- cli_tools/
    |   |       |-- dhcp_server/
    |   |       \-- ...
    |   |
    |   \-- galaxy
    |       \-- ...
    |             
    |
    |-- ff/
    |   |-- sn01.yml
    |   |-- sn02.yml
    |   |-- webserver.yml
    |   \-- ...
    |
    \-- ansible.cfg

**setup:**

``` shell
mkdir roles
git clone git@github.com:freifunkh/ansible.git roles/ff
mkdir roles/galaxy

git clone git@github.com:freifunkh/ansible-configs.git ff

mkdir inventory
ln -s ../ff/inventory inventory/ff

# ansible.cfg
cat > ansible.cfg <<EOF
[defaults]

inventory = inventory
roles_path = /etc/ansible/roles:roles/ff/roles:roles/galaxy
EOF

```

**deploy a host:**

``` shell
ansible-playbook ff/sn03.yml
```
