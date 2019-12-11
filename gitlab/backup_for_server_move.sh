#!/bin/bash
sudo gitlab-rake gitlab:backup:create BACKUP=dump GZIP_RSYNCABLE=yes STRATEGY=copy
