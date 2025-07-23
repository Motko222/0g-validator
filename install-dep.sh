#!/bin/bash

apt install lz4 -y

curl -L https://foundry.paradigm.xyz | bash
source /root/.bashrc
foundryup
