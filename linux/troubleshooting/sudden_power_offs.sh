#!/bin/bash
# https://unix.stackexchange.com/questions/9819/how-to-find-out-from-the-logs-what-caused-system-shutdown
grep -iv ': starting\|kernel: .*: Power Button\|watching system buttons\|Stopped Cleaning Up\|Started Crash recovery kernel' \
  /var/log/messages /var/log/syslog /var/log/apcupsd* \
  | grep -iw 'recover[a-z]*\|power[a-z]*\|shut[a-z ]*down\|rsyslogd\|ups'
