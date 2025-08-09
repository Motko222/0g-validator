sudo systemctl restart 0gchaind
sleep 10

sudo systemctl restart 0geth
sleep 2

sudo journalctl -u 0gchaind -u 0geth -f -o cat
