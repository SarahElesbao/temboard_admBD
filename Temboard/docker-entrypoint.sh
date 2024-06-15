#!/bin/bash
set -e

function runTemboard {
	if [ ! -f "/home/temboard/configured" ]
	then 
		echo "Configure Temboard.";
		sudo -iu postgres psql -d ${TEMBOARD_DATABASE} -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;";
		/bin/bash /usr/local/share/temboard/auto_configure.sh;
		temboard migratedb 'upgrade';
		sudo -iu postgres psql -d ${TEMBOARD_DATABASE} -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;";
		cp /etc/ssl/private/ssl-cert-snakeoil.key /home/temboard/etc/; 
		cp /home/temboard/etc/signing-* /home/temboard/;
		touch /home/temboard/configured;

	else 
		temboard --version;
	fi;

	sudo -iu root temboard -c /home/temboard/temboard.conf 2>&1;
}

function customize {
	sleep 15 && runTemboard &
}

customize & /usr/local/bin/docker-entrypoint.sh "$@"

