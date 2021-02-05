#!/bin/sh

git -C /etc log --reverse --grep "after Ansible" --oneline --format=tformat:"%ci@TAB@%s" | sed 's_\(pre\|post\)-commit changes \(after\|before\) Ansible runs\? (\([^@]*\)@[^,]*_\3_' | sed 's_)$__' | sed 's_@TAB@_\t_' | sed 's_, tags:_\ttags:_' | sed 's_,_, _' | sed 's_\t\(.\{1,6\}\)\t_\t\1 \t_' | python3 -c 'import sys; l = [c.split("\t") for c in sys.stdin.readlines()]; print("".join(["{x[0]:30}{x[1]:20}{x[2]}".format(x=x) for x in l]),end="")'
