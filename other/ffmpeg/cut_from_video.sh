#!/bin/bash
ffmpeg -i file.mp4 -ss 00:01:00 -t 00:02:00 -c copy output.mp4
