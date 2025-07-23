#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/cfg

ip=$(wget -qO- eth0.me)

sudo tee /etc/systemd/system/0gchaind.service > /dev/null << EOF
[Unit]
Description=0G Chain Daemon
After=network-online.target

[Service]
User=root
ExecStart=/root/galileo/bin/0gchaind start \
    --rpc.laddr tcp://0.0.0.0:28657 \
    --chaincfg.chain-spec devnet \
    --chaincfg.kzg.trusted-setup-path=kzg-trusted-setup.json \
    --chaincfg.engine.jwt-secret-path=jwt-secret.hex \
    --chaincfg.engine.rpc-dial-url=http://localhost:8751 \
    --chaincfg.kzg.implementation=crate-crypto/go-kzg-4844 \
    --chaincfg.block-store-service.enabled \
    --chaincfg.node-api.enabled \
    --chaincfg.node-api.logging \
    --chaincfg.node-api.address 0.0.0.0:3501 \
    --pruning=nothing \
    --home /root/0g-home/0gchaind-home \
    --p2p.seeds 85a9b9a1b7fa0969704db2bc37f7c100855a75d9@8.218.88.60:26656 \
    --p2p.external_address $ip:28656
Environment=CHAIN_SPEC=devnet
WorkingDirectory=/root/galileo
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/0geth.service > /dev/null << EOF
[Unit]
Description=0G geth Daemon
After=network-online.target

[Service]
User=root
ExecStart=/root/galileo/bin/geth \
    --config /root/galileo/geth-config.toml \
    --datadir /root/0g-home/geth-home \
    --networkid 16601 \
    --port 32303 \
    --http.port 8745 \
    --ws.port 8746 \
    --authrpc.port 8751
Environment=CHAIN_SPEC=devnet
WorkingDirectory=/root/galileo
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable 0gchaind.service
sudo systemctl enable 0geth.service


