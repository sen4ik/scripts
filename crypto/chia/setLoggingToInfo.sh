#!/bin/bash
sed -i 's/WARNING/INFO/g' ~/.chia/mainnet/config/config.yaml && cat ~/.chia/mainnet/config/config.yaml | grep INFO
