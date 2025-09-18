tag=v2.0.4
cd /root
rm -r galileo
wget -O galileo.tar.gz https://github.com/0glabs/0gchain-NG/releases/download/$tag/galileo-$tag.tar.gz
tar -xzvf galileo.tar.gz -C ~
mv galileo-$tag galileo
cd galileo
cp -r 0g-home /root
sudo chmod 777 ./bin/geth
sudo chmod 777 ./bin/0gchaind

