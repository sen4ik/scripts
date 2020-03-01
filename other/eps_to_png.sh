#!/bin/bash

# sudo apt install -y imagemagick 

command -v convert >/dev/null 2>&1 || { echo "Script requires imagemagick but it's not installed. Aborting." >&2; exit 1; }

filetype="eps"

find -name "* *.${filetype}" -type f | rename 's/ /_/g'

for f in `ls *.${filetype}`; do
    echo "Converting ${f%.*}.${filetype}"
    convert -density 150 $f -flatten "${f%.*}.png";
done