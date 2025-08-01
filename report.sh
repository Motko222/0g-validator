#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=~/logs/report-$folder
source ~/.bash_profile
source $path/env

version=$(/root/galileo/bin/0gchaind version)" / "$(/root/galileo/bin/geth version | grep "^Version: " | awk '{print $NF}')
service_chain=$(sudo systemctl status 0gchaind --no-pager | grep "active (running)" | wc -l)
service_geth=$(sudo systemctl status 0geth --no-pager | grep "active (running)" | wc -l)
errors_chain=$(journalctl -u 0gchaind.service --since "1 hour ago" --no-hostname -o cat | grep -c -E "rror|ERR")
errors_geth=$(journalctl -u 0geth.service --since "1 hour ago" --no-hostname -o cat | grep -c -E "rror|ERR")

node_height=$(echo $(( 16#$(curl -s localhost:8745 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result | sed 's/0x//') )))
chain_height=$(echo $(( 16#$(curl -s https://evmrpc-testnet.0g.ai -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result | sed 's/0x//') )))
diff=$(( $chain_height - $node_height ))
url=$(wget -qO- eth0.me):8745

status="ok";message="";
[ $diff -gt 20 ] && status="warning" && message="syncing (behind $diff)";
if [ $errors_chain -gt 500 ] || [ $errors_geth -gt 500 ]
then status="warning" && message="too many errors ($errors_chain/$errors_geth)";
fi
if [ $service_chain -ne 1 ] || [ $service_geth -ne 1 ]
then status="error" && message="service not running (chain=$service_chain geth=$service_geth)";
fi

cat >$json << EOF
{
  "updated":"$(date --utc +%FT%TZ)",
  "measurement":"report",
  "tags": {
     "id":"$folder-$ID",
     "machine":"$MACHINE",
     "grp":"node",
     "owner":"$OWNER"
  },
  "fields": {
     "network":"testnet",
     "chain":"galileo",
     "status":"$status",
     "version":"$version",
     "message":"$message",
     "m1":"moniker=$MONIKER",
     "url":"$url",
     "errors":"$service_chain/$service_geth",
     "height":"$node_height"
  }
}
EOF
cat $json | jq
