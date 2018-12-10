#!/usr/bin/env expect
set timeout -1
set install_dir [lindex $argv 0]
set petalinux_version [lindex $argv 1]

spawn ./petalinux-v${petalinux_version}-final-installer.run $install_dir
expect "Press Enter to display the license agreements"
send "\r"
expect "*>*"
send "y\r"
expect "*>*"
send "y\r"
expect eof
