#!/bin/bash

cd ~ || exit

systemctl stop titan
cp -r ~/.titan ~/titan_bak

# shellcheck disable=SC2046
rm $(which titand)

#下载
wget -P ~/. https://github.com/Titannet-dao/titan-chain/releases/download/v2.0.0/titan_chain_v2.0.0_linux_amd.tar.gz
tar -zxvf ~/titan_chain_v2.0.0_linux_amd.tar.gz  --strip-components 1 -C /usr/local/bin
rm ~/titan_chain_v2.0.0_linux_amd.tar.gz

# 替换下载链接
#wget -P ~/. https://github.com/Titannet-dao/titan-node/releases/download/v0.1.19/titan-l2edge_v0.1.19_patch_linux_amd64.tar.gz
cp ~/bakbak/genesis.json ~/genesis.json
mv ~/genesis.json ~/.titan/config/genesis.json

rm -r ~/.titan/data
mkdir ~/.titan/data
echo '{
  "height": "0",
  "round": 0,
  "step": 0
}' > ~/.titan/data/priv_validator_state.json

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

systemctl start titan
