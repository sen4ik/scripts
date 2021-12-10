#!/bin/sh

BACKUP_FROM=/mnt/Vol1/MyFiles/Photos
BACKUP_TO=/media/WD1TB/MyFiles/Backups
LOGSDIR=$BACKUP_TO/logs

sudo rsync --perms --recursive --times --verbose --progress \
--itemize-changes --log-file=$LOGSDIR/rsync-$(date +%Y-%m-%d).txt --log-file-format="%i %f %b" \
--copy-links $BACKUP_FROM $BACKUP_TO

# verify
# rsync -avhc $BACKUP_FROM $BACKUP_TO
# rsync --dry-run --checksum --itemize-changes --archive $BACKUP_FROM $BACKUP_TO
