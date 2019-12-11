#!/bin/sh

BACKUPFROM=/var/opt/gitlab/backups
BACKUPTO=/mnt/p1/backups/gitlab/rsynced

runBackup() {
  LOGSDIR=$BACKUPTO/logs
  LOGFILE=$LOGSDIR/gitlab_rsync-$(date +%Y-%m-%d).txt
  touch $LOGFILE
  rsync --perms --recursive --times --compress --verbose \
  --itemize-changes --log-file=$LOGFILE --log-file-format="%i %f %b" \
  --copy-links \
  --exclude-from=$BACKUPTO/exclude.txt \
  --rsh "ssh -p2222" sen4ik@XXX.XXX.XXX.XXX:$BACKUPFROM $BACKUPTO
}

runBackup
