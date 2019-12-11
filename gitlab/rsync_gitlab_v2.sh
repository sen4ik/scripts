#!/bin/sh

GITLABHOSTIP=XXX.XXX.XXX.XXX
BACKUPFROM=/var/opt/gitlab/backups
BACKUPTO=/mnt/p1/backups/gitlab/rsynced

# https://askubuntu.com/questions/719439/using-rsync-with-sudo-on-the-destination-machine

runBackup() {
  LOGSDIR=$BACKUPTO/logs
  LOGFILE=$LOGSDIR/gitlab_rsync-$(date +%Y-%m-%d).log
  touch $LOGFILE
  rsync --perms --recursive --times --compress --verbose \
  --itemize-changes --log-file=$LOGFILE --log-file-format="%i %f %b" \
  --copy-links \
  --exclude-from=$BACKUPTO/exclude.txt \
  --rsync-path="sudo rsync" \
  --rsh "ssh -p2222" sen4ik@$GITLABHOSTIP:$BACKUPFROM $BACKUPTO
}

ping -q -c5 $GITLABHOSTIP > /dev/null 
if [ $? -eq 0 ]
then
    echo "Ping OK"
    runBackup
else
    echo "Can't ping $GITLABHOSTIP"
    exit 1
fi

