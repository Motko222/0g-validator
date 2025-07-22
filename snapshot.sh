read -p "Sure? " c
case $c in y|Y) ;; *) exit ;; esac

sudo systemctl stop 0gchaind 0geth
mv /root/0g-home/0gchaind-home/data/priv_validator_state.json /root/priv_validator_state.json.backup
rm -rf /root/0g-home/0gchaind-home/data
rm -rf /root/0g-home/geth-home/geth/chaindata
mkdir -p /root/0g-home/geth-home/geth

SNAPSHOT_URL="https://files.mictonode.com/0g/snapshot/"
LATEST_COSMOS=$(curl -s $SNAPSHOT_URL | grep -oP '0g_\d{8}-\d{4}_\d+_cosmos\.tar\.lz4' | sort | tail -n 1)
LATEST_GETH=$(curl -s $SNAPSHOT_URL | grep -oP '0g_\d{8}-\d{4}_\d+_geth\.tar\.lz4' | sort | tail -n 1)

if [ -n "$LATEST_COSMOS" ] && [ -n "$LATEST_GETH" ]; then
  COSMOS_URL="${SNAPSHOT_URL}${LATEST_COSMOS}"
  GETH_URL="${SNAPSHOT_URL}${LATEST_GETH}"

  if curl -s --head "$COSMOS_URL" | head -n 1 | grep "200" > /dev/null && \
     curl -s --head "$GETH_URL" | head -n 1 | grep "200" > /dev/null; then

    curl "$COSMOS_URL" | lz4 -dc - | tar -xf - -C /root/0g-home/0gchaind-home
    curl "$GETH_URL" | lz4 -dc - | tar -xf - -C /root/0g-home/geth-home/geth

    mv /root/priv_validator_state.json.backup /root/0g-home/0gchaind-home/data/priv_validator_state.json

    sudo systemctl restart 0geth
    sleep 5
    sudo systemctl restart 0gchaind

    sudo journalctl -u 0gchaind -u geth -f -o cat
  else
    echo "Snapshot URL is not accessible"
  fi
else
  echo "No snapshot found"
fi
