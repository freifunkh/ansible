#!/bin/sh

peoples=$(while read foo; do
	key=$(echo $foo | cut -d ' ' -f 2 | base64 -d | sha256sum -b | awk '{print $1}' | xxd -r -p | base64 | tr -d '=')
	name=$(echo $foo | cut -d ' ' -f 3-)
	if [ "$name" = "" ]; then
		name="UNKNOWN";
	fi
	echo $key $name "%%%"
done</root/.ssh/authorized_keys)

get_person() {
	echo $peoples | sed "s_%%%_\n_g" | grep $1 | awk '{ print $2 }'
}

logs () {
	cat /var/log/auth.log.1
	cat /var/log/auth.log
}

logins=$(logs | grep "Accepted publickey for" | awk '{print $1 " " $2 " " $3 ";" $16 }' | sed 's_SHA256:__')

echo "$logins" | while read line; do 
	time=$(echo $line | cut -d\; -f 1)
	key=$(echo $line | cut -d\; -f 2)
	person=$(get_person ${key})

	printf '%-4s %-3s %-7s %-20s\n' ${time} ${person}
done
