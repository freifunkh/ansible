# ffh supernodes

## deployment

Ansible does not need any agent on the remotes. The only requirements
on the remote machine are ```ssh``` and ```python2```. On your local
machine you need ansible installed.

1. Add the new host to your ansible hosts config ```/etc/ansible/hosts```.
2. Add the configuration for the new host to ```sn.yml```.
3. Start deployment: ```ansible-playbook sn.yml```
4. Since the new host needs to get access to the remote git, the
   script will pause and wait until you have deployed the generated key
   ```/home/auto/.ssh/id_rsa.pub``` to the git server. When you have
   done this, you should verify that you can access the git. Then you can
   delete the lockfile ```/home/auto/wait_for_access.lock``` and ansible
   should continue with the deployment. If you fail deploying the key properly,
   the git clone command will wait an nearly infinite time for an entered
   password (which will never happen).
5. You should be ready.


## role descriptions

### basic helper roles

- **cli\_tools:** install some cli tools
    - ```netcat-openbsd```
    - ```tcpdump```
- **ssh\_known\_hosts:** install systemwide known_hosts to verify remotes
- **git\_autoupdate:** autoupdate git repositorys
    - provides generic update script for use in cronjobs
        - ```/home/auto/autoupdate.sh <repo-path>```
        - exit status indicates whether the repo has changed
    - cronjobs should run as user: ```auto```


### mesh networking roles

The basic functionality is provided by the batman role. It handles the proper
configuration of the bat0 interface. But the interface is only created, if
we have at least one "mesh provider".

- **batman:** ensures the batman kmod is loaded
    - interface is not created without mesh provider

The only existing provider is fastd_mesh at the moment. This role creates a
fastd instance and binds it to batman. But it does not accept a connection
from any peer until you add at lease one "remotes provider".

- **fastd\_mesh:** adds fastd_mesh interface to bat0
    - host vars: ```fastd_mesh_mac```
    - doesn't work without remotes role

There are two different remotes providers:

- **fastd\_mesh\_remotes\_backbone:** provides access to other supernodes
- **fastd\_mesh\_remotes\_peers\_git:** provide access to peers repo
    - host vars: ```git_addr```
    - installs cronjob to autoupdate peers
