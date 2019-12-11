#!/bin/sh
find rsynced/backups/* -mtime +30 -exec rm -rf {} \;
