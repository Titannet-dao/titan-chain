#!/bin/bash

# 进入用户目录
cd ~ || exit

# 停止当前 titan 程序
systemctl stop titan

# 备份 titan 目录,如果中间出错,可以使用备份恢复后重新执行
cp -r ~/.titan ~/titan_bak

# 删除现有可执行程序
# shellcheck disable=SC2046
rm $(which titand)

# 下载新可执行程序
wget -P ~/. https://github.com/Titannet-dao/titan-chain/releases/download/v2.0.0/titan_chain_v2.0.0_linux_amd.tar.gz
# 解压缩可执行程序到全局目录中
tar -zxvf ~/titan_chain_v2.0.0_linux_amd.tar.gz  --strip-components 1 -C /usr/local/bin
# 删除下载的包
rm ~/titan_chain_v2.0.0_linux_amd.tar.gz

# 替换下载链接
#wget -P ~/. https://github.com/Titannet-dao/titan-node/releases/download/v0.1.19/titan-l2edge_v0.1.19_patch_linux_amd64.tar.gz
cp ~/bakbak/genesis.json ~/genesis.json

# 替换新创世文件
mv ~/genesis.json ~/.titan/config/genesis.json

# 删除旧链数据目录
rm -r ~/.titan/data
# 创建新链数据目录
mkdir ~/.titan/data
# 构建 data/priv_validator_state.json 文件
echo '{
  "height": "0",
  "round": 0,
  "step": 0
}' > ~/.titan/data/priv_validator_state.json

# 更新 config/client  中的 chain-id
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

# 启动新的titan 程序
systemctl start titan
