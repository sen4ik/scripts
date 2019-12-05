#!/bin/bash
sudo docker-compose --file docker-compose.yaml up --scale chrome=5 -d
