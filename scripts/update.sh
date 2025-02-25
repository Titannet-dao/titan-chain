#!/bin/bash

# Enter user directory
cd ~ || exit

# Stop old titan program
systemctl stop titan

# Remove old titand program
rm $(which titand)

# Download new programs
wget -P ~/. https://github.com/Titannet-dao/titan-chain/releases/download/v0.3.0/titand_0.3.0-1_g167b7fd6.tar.gz

# Unzip to the specified directory
tar -zxvf ~/titand_0.3.0-1_g167b7fd6.tar.gz  --strip-components=1 -C /usr/local/bin

# Back up the .titan directory. If something goes wrong in the middle, you can use the backup to restore and then execute again.
mv ~/.titan ~/titan_bak_test_3

# Copy directory and other information to the new path
rsync -av --exclude "data" ~/titan_bak_test_3/* ~/.titan

rm ~/genesis.json

# Download new genesis file
wget -P ~/. https://github.com/Titannet-dao/titan-chain/releases/download/v0.3.0/genesis.json

# Replace new genesis file
mv ~/genesis.json ~/.titan/config/genesis.json

wget -P ~/. https://github.com/Titannet-dao/titan-chain/releases/download/v0.3.0/libwasmvm.x86_64.so

mv ~/libwasmvm.x86_64.so /usr/local/lib/libwasmvm.x86_64.so

sudo ldconfig

mkdir ~/.titan/data
# Build data/priv_validator_state.json 文件
echo '{
  "height": "0",
  "round": 0,
  "step": 0
}' > ~/.titan/data/priv_validator_state.json

# Update config/client.toml chain-id
echo '# This is a TOML config file.
# For more information, see https://github.com/toml-lang/toml

###############################################################################
###                           Client Configuration                            ###
###############################################################################

# The network chain ID
chain-id = "titan-test-4"
# The keyring s backend, where the keys are stored (os|file|kwallet|pass|test|memory)
keyring-backend = "os"
# CLI output format (text|json)
output = "json"
# <host>:<port> to Tendermint RPC interface for this chain
node = "tcp://localhost:26657"
# Transaction broadcasting mode (sync|async)
broadcast-mode = "sync"' > ~/.titan/config/client.toml

systemctl start titan