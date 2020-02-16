#!/bin/bash

# https://unix.stackexchange.com/questions/57305/rsync-compare-directories
# Here's an example of the output:
# L             file-only-in-Left-dir
# R             file-only-in-right-dir
# X >f.st...... file-with-dif-size-and-time
# X .f...p..... file-with-dif-perms

LEFT_DIR=sen4ik@192.168.11.11:/mnt/vol1/pics
RIGHT_DIR=/Volumes/MyFiles/pics
rsync -rin --exclude-from 'exclude-list.txt' --rsync-path="sudo rsync" --ignore-existing --rsh "ssh -p2222" "$LEFT_DIR"/ "$RIGHT_DIR"/ | sed -e 's/^[^ ]* /L             /'
rsync -rin --exclude-from 'exclude-list.txt' --rsync-path="sudo rsync" --ignore-existing --rsh "ssh -p2222" "$RIGHT_DIR"/ "$LEFT_DIR"/ | sed -e "s/^[^ ]* /R             /"
rsync -rin --exclude-from 'exclude-list.txt' --rsync-path="sudo rsync" --existing --rsh "ssh -p2222" "$LEFT_DIR"/ "$RIGHT_DIR"/ | sed -e "s/^/X /"
