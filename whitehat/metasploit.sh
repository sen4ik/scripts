#!/bin/bash
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
chmod 755 msfinstall
./msfinstall
msfdb init
msfconsole

# Check msf database connection
# msf > db_status

# Update metasploit
# msfupdate

# msfconsole --version
