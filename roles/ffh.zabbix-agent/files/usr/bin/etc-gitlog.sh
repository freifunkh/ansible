#!/bin/bash

if [ "$1" = "whitelisting" ]; then
	shift;
	# as we do whitelisting here, manually made commits will be excluded from the log

	EXTRA_ARGS=(--grep pre-commit --grep autocommit)
else
	# as we do blacklisting, manually made commits will be included

	EXTRA_ARGS=(--invert-grep --grep post-commit --grep "after apt run")
fi

echo
echo
/usr/bin/git -C /etc log "$@" "${EXTRA_ARGS[@]}" -- . ":(exclude).etckeeper" ":(exclude)fastd/peers"
