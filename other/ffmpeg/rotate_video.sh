#!/bin/bash
ffmpeg -i input.mp4 -vf "transpose=0" output.mp4

# transpose can be 0,1,2,3