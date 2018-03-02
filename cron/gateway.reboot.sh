#!/usr/bin/expect -f
# or
# http://192.168.0.252/MAINTENANCE/reboot.xgi
# RouterOS
# /tool fetch url=http://192.168.0.252/MAINTENANCE/reboot.xgi user=cht password=chtnvdsl

spawn ssh cht@192.168.0.252
expect {
	"password: " {
		send_user "<Enter Password ...>\n"
		send "chtnvdsl\r"
	} incorrect {
		send_user "<invalid password or account>\n"
		exit
	} timeout {
		send_user "<Timeout on Password>\n"
		exit
	} eof {
		send_user "<Connection Failed on Password>\n"
		exit
	}
}

expect {
	"21." {
		send_user "<Enter Selection 20>\n"
		send "20\r"
	} timeout {
		send_user "<Timeout on Option 1>\n"
		exit
	} eof {
		send_user "<Connection Failed on Option 1>\n"
		exit
	}
}

expect {
	"07." {
		send_user "<Enter Selection 1>\n"
		send "1\r"
	} timeout {
		send_user "<Timeout on Option 2>\n"
		exit
	} eof {
		send_user "<Connection Failed on Option 2>\n"
		exit
	}
}

expect {
	"Confirm Reboot" {
		send_user "<Enter Selection y>\n"
		send "y\r"
	} timeout {
		send_user "<Timeout on Option 3>\n"
		exit
	} eof {
		send_user "<Connection Failed on Option 3>\n"
		exit
	}
}

#sleep 10
expect {
	"cleanup" {
		send_user "<Complete>\n"
		sleep 10
		exit
	} timeout {
		send_user "<Timeout on Final>\n"
		exit
	} eof {
		send_user "<Connection Failed on Final>\n"
		exit
	}
}

#spawn mailx -s "[LOG] $(hostname) $0" -r "Sita Liu<egreta.su@msa.hinet.net>" -S smtp="msa.hinet.net" chsliu@gmail.com </dev/null
