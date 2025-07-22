cd /root
rm -r galileo
wget -O galileo.tar.gz https://github.com/0glabs/0gchain-NG/releases/download/v1.2.0/galileo-v1.2.0.tar.gz
tar -xzvf galileo.tar.gz -C ~
mv galileo-v1.2.0 galileo
cd galileo
cp -r 0g-home /root
sudo chmod 777 ./bin/geth
sudo chmod 777 ./bin/0gchaind

