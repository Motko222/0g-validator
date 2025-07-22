#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env

cd /root/galileo/bin
./0gchaind deposit validator-keys --home $HOMEDIR --chaincfg.chain-spec=$CHAIN_SPEC
