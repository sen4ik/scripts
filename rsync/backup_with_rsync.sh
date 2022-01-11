#!/bin/sh

BACKUP_FROM=/mnt/Vol1/MyFiles/Photos
BACKUP_TO=/media/WD1TB/MyFiles/Backups

runSync() {
  LOGSDIR=$2/logs
  rsync --perms --recursive --times --compress --verbose \
  --itemize-changes --log-file=$LOGSDIR/rsync-$(date +%Y-%m-%d-%H-%M-%S).txt --log-file-format="%i %f %b" \
  --copy-links \
  --delete-excluded --delete \
  --exclude-from=$2/exclude.txt \
  --rsh "ssh -p1234" sen4ik@192.168.111.111:$1 $2
}

runSync $BACKUP_FROM $BACKUP_TO
