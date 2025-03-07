#!/usr/bin/env expect

set timeout 10

set cmd [lrange $argv 1 end]
set password [lindex $argv 0]

eval spawn $cmd
expect "Enter passphrase"
send "$password\r"
interact
