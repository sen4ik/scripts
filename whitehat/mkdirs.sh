#!/bin/bash
TOOLS=~/tools
TARGETS=~/targets

if [ ! -d "$TOOLS" ]; then
  mkdir $TOOLS
fi

if [ ! -d "$TARGETS" ]; then
  mkdir $TARGETS
fi
