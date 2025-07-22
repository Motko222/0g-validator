#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
cd $path
source $path/env
c=$(cat test-rpc | wc -l)

echo "------------------------"
for (( i=1;i<=$c;i++ ))
do
   rpc=$(cat test-rpc | head -$i | tail -1)
   printf "%s %-40s" $i $rpc
   node_height=$(echo $(( 16#$(curl -s $rpc -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result | sed 's/0x//') )))
   printf "%s \n" $node_height
done

echo "------------------------"
