# ffh.taskserver role

This role sets up the server instance for [taskwarrior](https://taskwarrior.org/).
In this process its setting up a certificate authority and creates certs for every entity registered as admin by the admin role.

It does not overwrite existing certifcates if run more than once.

Warning: I firewalls are used, the ferm role needs to run after this one once to open its port.


So, to become a registered user, add yourself to the admin-key list like described in the admin role:

**add user:**

    - admin_pubkeys:
      - name: hans
        key: ssh-rsa ...
      - name: susanne
        key: ssh-ed25519 ...

## client setup

at first, setup an alias in your .bash_aliases like this:

```
alias ffhtask="task rc:~/.ffhtaskrc"
```

then install taskwarrior, eg:

```
sudo apt install task
```

or

```
sudo pacman -S task
```

run it once:

```
task
```

then copy the implicitely created .taskrc to .ffhtaskrc and change the data.location to ~/.ffhtask

```
cp .taskrc .ffhtaskrc
```
edit data.location now!

Also create a new directory for ffh taskwarrior data:
```
mkdir .ffhtaskdata
```

From now on, you can handle freifunk-related tasks completely seperated from the ones that you manage privtaely. (the commands are ffhtask and task)


In order to sync your ffh tasks with us others, login to the webserver and run the tw_helper.sh.

```
./tw_helper.sh
```

Should it be gone, the code is appended at the bottom.

Execute the lines it outputs on your local machine and watch the output for errors.

Afterwords you should be able to execute this:

```
ffhtask sync
```

And be rewarded with something like: `Sync successful.`

-----------------------------
-----------------------------
The contents of the tw_helper.sh on the webserver:



```
#!/bin/bash
if [ -z "$1" ];
then
	echo "usage: Look up your username in this file in the section admin_keys:"
	echo "https://github.com/freifunkh/ansible-configs/blob/master/vars/all_hosts.yml"
	echo ""
	echo "$0 <your-username>"
	exit
fi

tsuser=$1
tsorg=freifunkh

idfile=$(grep -rni =$tsuser /var/lib/taskd/orgs/$tsorg/)
if [ -z $idfile ]
then
	echo "User $user does not exist in organization $tsorg."
	exit
fi
if [ $(echo $idfile | wc -l) -gt 1 ]
then
	echo "User $user does exist more than once in organization $tsorg."
	exit
fi

id=$(echo $idfile | cut -d"/" -f8)
founduser=$(echo $idfile | cut -d"=" -f2)

echo "mkdir -p ~/.ffhtask"
echo "cd ~/.ffhtask"

echo "scp -P 1337 root@web.ffh.zone:.config/taskd/ca.cert.pem ."
echo "scp -P 1337 root@web.ffh.zone:.config/taskd/$founduser.* ."

echo "yes | ffhtask config taskd.certificate -- ~/.ffhtask/$founduser.cert.pem"
echo "yes | ffhtask config taskd.key -- ~/.ffhtask/$founduser.key.pem"
echo "yes | ffhtask config taskd.ca -- ~/.ffhtask/ca.cert.pem"
echo "yes | ffhtask config taskd.server -- web.ffh.zone:53589"
echo "yes | ffhtask config taskd.credentials -- $tsorg/$founduser/$id"
echo ""
```





