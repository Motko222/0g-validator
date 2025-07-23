#!/bin/bash
path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env

cd /root/galileo
./bin/geth init --datadir /root/0g-home/geth-home ./genesis.json
./bin/0gchaind init $MONIKER --home /root/tmp

cp /root/tmp/data/priv_validator_state.json /root/0g-home/0gchaind-home/data/
cp /root/tmp/config/node_key.json /root/0g-home/0gchaind-home/config/
cp /root/tmp/config/priv_validator_key.json /root/0g-home/0gchaind-home/config/
