#!/bin/bash

export path=$path:/usr/local/bin/:/usr/bin/
c9ssh_root=/Applications/c9ssh/


sleep_interval=60
daemon=nat123
daemon1=nat123a
daemon2=nat123b

function online {
	echo -e "GET http://baidu.com HTTP/1.0\n\n" | nc baidu.com 80 > /dev/null 2>&1
	if [ $? -eq 0 ]; then
	    echo "true"
	else
	    echo "false"
	fi
}

function remote_daemon1 {
	echo 'start remote_daemon1'
	screen -dmS $daemon1 /usr/local/bin/mono $c9ssh_root'nat123linux.sh' autologin  stone55 ft123456!
}

function remote_daemon2 {
	echo 'start remote_daemon2'
	screen -dmS $daemon2 /usr/local/bin/mono $c9ssh_root'nat123linux.sh' service
}

function kill_daemon {
	screen -X -S $daemon quit
	echo 'kill_daemon'
}


function kill_daemon1 {
	screen -X -S $daemon1 quit
	echo 'kill_daemon1'
}

function kill_daemon2 {
	screen -X -S $daemon2 quit
	echo 'kill_daemon2'
}

function remote_daemon1 {
	kill_daemon1
	echo 'start remote_daemon1'
	screen -dmS $daemon1 /usr/local/bin/mono $c9ssh_root'nat123linux.sh' autologin  stone55 ft123456!
}

function remote_daemon2 {
	kill_daemon2
	echo 'start remote_daemon2'
	screen -dmS $daemon2 /usr/local/bin/mono $c9ssh_root'nat123linux.sh' service
}

function nat_daemon {
	sync="false"
	newstatus=$(online)
	status=$newstatus
	while true; do
	if [ "$sync" == "false" ]; then
		if [ "$status" == "true" ]; then
			echo 'start remote_daemon'
			remote_daemon1
			sleep 5
			remote_daemon2
			sync="true"
			status=$newstatus
		else
			kill_daemon1
			kill_daemon2
			sync="true"
			status=$newstatus
		fi
	else
		sleep $sleep_interval
		echo 'sleep '$sleep_interval
		newstatus=$(online)
		if [ ! "$newstatus" == "$status" ]; then
			sync="false"
			status=$newstatus
		fi
	fi
	done
}

kill_daemon
screen -dmS $daemon nat_daemon
# nat_daemon
