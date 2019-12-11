#!/bin/bash
sudo gitlab-rake gitlab:backup:create GZIP_RSYNCABLE=yes STRATEGY=copy
