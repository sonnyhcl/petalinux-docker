#!/usr/bin/env expect
set timeout -1
set install_dir [lindex $argv 0]
set version [lindex $argv 1]

send_user "install dir is $install_dir\n"
send_user "version is $version\n"

spawn ./petalinux-v$version-final-installer.run $install_dir
expect "Press Enter to display the license agreements"
send "\r"
expect "*>*"
send "y\r"
expect "*>*"
send "y\r"
expect "*>*"
send "y\r"
expect eof
