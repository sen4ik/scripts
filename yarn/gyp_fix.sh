#!/bin/bash
sudo rm -r -f $(xcode-select --print-path)
xcode-select --install