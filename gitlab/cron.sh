#!/bin/bash
crontab -l > mycron
echo "0 2 * * * /opt/gitlab/bin/gitlab-rake gitlab:backup:create CRON=1 GZIP_RSYNCABLE=yes STRATEGY=copy" >> mycron
crontab mycron
rm mycron