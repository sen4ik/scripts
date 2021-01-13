#!/bin/bash
printf "file '%s'\n" ./*.mp4> list.txt
ffmpeg -f concat -i list.txt -c copy output.mp4
