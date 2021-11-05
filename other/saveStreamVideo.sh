#!/bin/bash
for i in $(seq -f "%05g" 1 99999)
do
  wget https://streaming.example.net/video/lesson_1_1080p_$i.ts
  if [[ $? -ne 0 ]]; then
    echo "wget failed"
    exit 1; 
  else
  	echo "wget success"
  fi
done
printf "file '%s'\n" ./*.ts > mylist.txt
ffmpeg -f concat -safe 0 -i mylist.txt -c copy output.ts
rm mylist.txt