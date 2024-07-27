#!/bin/bash

# Enter user directory
cd ~ || exit

# Stop old titan program
systemctl stop titan

# Back up the .titan directory. If something goes wrong in the middle, you can use the backup to restore and then execute again.
cp -r ~/.titan ~/titan_bak

# Delete existing executable program
# shellcheck disable=SC2046
rm $(which titand)

# Download new executable program
wget -P ~/. https://github.com/Titannet-dao/titan-chain/releases/download/v2.0.0/titan_chain_v2.0.0_linux_amd.tar.gz
# Unzip the executable program into the global directory
tar -zxvf ~/titan_chain_v2.0.0_linux_amd.tar.gz  --strip-components 1 -C /usr/local/bin
# Delete downloaded packages
rm ~/titan_chain_v2.0.0_linux_amd.tar.gz

# Download new genesis file
wget -P ~/. https://raw.githubusercontent.com/Titannet-dao/titan-chain/main/genesis/genesis.json

# Replace new genesis file
mv ~/genesis.json ~/.titan/config/genesis.json

# Delete old chain data directory
rm -r ~/.titan/data
# Create a new chain data directory
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
chain-id = "titan-test-2"
# The keyring s backend, where the keys are stored (os|file|kwallet|pass|test|memory)
keyring-backend = "os"
# CLI output format (text|json)
output = "text"
# <host>:<port> to Tendermint RPC interface for this chain
node = "tcp://localhost:26657"
# Transaction broadcasting mode (sync|async)
broadcast-mode = "sync"' > ~/.titan/config/client.toml

# Start a new titan program
systemctl start titan
