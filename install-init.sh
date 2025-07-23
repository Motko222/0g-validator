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

sed -i -e "
s%:26658%:${OG_PORT}658%g;
s%:26657%:${OG_PORT}657%g;
s%:6060%:${OG_PORT}060%g;
s%:26656%:${OG_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${OG_PORT}656\"%;
s%:26660%:${OG_PORT}660%g
" /root/0g-home/0gchaind-home/config/config.toml

sed -i -e "s|^node *=.*|node = \"tcp://localhost:${OG_PORT}657\"|" /root/0g-home/0gchaind-home/config/client.toml
sed -i -e "s|^keyring-backend *=.*|keyring-backend = \"os\"|" /root/0g-home/0gchaind-home/config/client.toml

sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" /root/0g-home/0gchaind-home/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" /root/0g-home/0gchaind-home/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" /root/0g-home/0gchaind-home/config/app.toml
