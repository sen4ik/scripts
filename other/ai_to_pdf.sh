#!/bin/bash

command -v gs >/dev/null 2>&1 || { echo "Script requires GhostScript but it's not installed. Aborting." >&2; exit 1; }

filetype="ai"

find -name "* *.${filetype}" -type f | rename 's/ /_/g'

for f in `ls *.${filetype}`; do
    echo "Converting ${f%.*}.${filetype}"
    gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="${f%.*}.pdf" $f
    # gs -dNOPAUSE -dBATCH -sDEVICE=eps2write -sOutputFile=out.eps file.ai
done