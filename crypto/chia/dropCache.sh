#!/bin/bash
date; sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches && sudo swapoff -a && sudo swapon -a; date
