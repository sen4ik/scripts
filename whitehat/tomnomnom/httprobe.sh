#!/bin/sh
cat domains | httprobe | tee hosts
