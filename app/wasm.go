package app

import (
	wasmkeeper "github.com/Titannet-dao/titan-chain/x/wasm/keeper"
)

// Deprecated: Use BuiltInCapabilities from github.com/CosmWasm/wasmd/x/wasm/keeper
func AllCapabilities() []string {
	return wasmkeeper.BuiltInCapabilities()
}
