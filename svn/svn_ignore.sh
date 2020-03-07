#!/bin/bash
SNV_IGNORE=svn_ignore.txt
echo -e ".idea\n*.iml\ntarget\nlogs\n${SNV_IGNORE}" > $SNV_IGNORE
svn propset svn:ignore -F $SNV_IGNORE .
svn propget svn:ignore .