sudo systemctl restart 0geth
sleep 2
sudo systemctl restart 0gchaind
sleep 2
sudo journalctl -u 0gchaind -u geth -f -o cat
