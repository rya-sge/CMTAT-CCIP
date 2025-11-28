# Guideline

This repository contains a collection of Foundry scripts designed to simplify interactions with CCIP 1.6 contracts with CMTAT.

Find a list of available tutorials on the Chainlink documentation: [Cross-Chain Token (CCT) Tutorials](http://docs.chain.link/ccip/tutorials/cross-chain-tokens#overview).

## Scripts

All scripts are available in the directory `script`.

| Script                         | Purpose                                                      |
| ------------------------------ | ------------------------------------------------------------ |
| **AcceptAdminRole**            | Allows the *pending administrator* of a token to accept the admin role in `TokenAdminRegistry`. Reads token address from JSON, validates the caller is the pending admin, then calls `acceptAdminRole`. |
| **AddRemotePool**              | Adds a remote pool to a token pool to enable cross-chain connectivity. Validates the remote chain configuration and encodes the remote pool address. Calls `addRemotePool` on the pool contract. |
| **ApplyChainUpdates**          | Configures cross-chain mappings for a local pool. Reads local pool, remote pool, and remote token from JSON, fetches the remote chain selector, prepares a `ChainUpdate` with **disabled rate limiters**, and applies it to the pool. |
| **ClaimAdmin**                 | Claims CCIP admin role for a deployed token. Checks that the caller matches the token’s CCIP admin, then calls `registerAdminViaGetCCIPAdmin` on `RegistryModuleOwnerCustom`. |
| **DeployBurnMintTokenPool**    | Deploys a `BurnMintTokenPool` for a previously deployed token. Grants mint, burn, and `BURNER_FROM_ROLE` permissions to the pool. Saves deployed pool address to JSON. |
| **DeployLockReleaseTokenPool** | Deploys a `LockReleaseTokenPool` for a deployed token. Saves the deployed pool address to JSON. Requires router and RMN proxy addresses from network config. |
| **DeployToken**                | Deploys a CMTAT token (`CMTATStandalone`). Grants CCIP admin role to deployer. Writes the deployed token address to JSON. |
| **GetCurrentRateLimits**       | Reads the inbound and outbound rate limiter state for a pool on a remote chain. Validates pool address and chain configuration. Logs token count, last update, enabled status, capacity, and refill rate. |
| **GetPoolConfig**              | Displays full pool configuration including remote mappings, rate limiters, allow lists, router, and token addresses. Decodes remote pool addresses and token addresses for all supported chains. |
| **MintTokens**                 | Mints tokens to the caller’s address. Reads token address from JSON and requires **amount** to be passed as a function argument. Uses `BurnMintERC20.mint`. |
| **RemoveRemotePool**           | Removes a remote pool from a token pool, disabling cross-chain interaction. Validates pool owner, remote chain configuration, and encodes remote pool address. Logs warning about inflight transactions being rejected. |
| **SetPool**                    | Registers a token’s pool in the `TokenAdminRegistry`. Reads token and pool addresses from JSON and calls `setPool`. Logs the token administrator performing the action. |
| **SetRateLimitAdmin**          | Sets a new rate limit administrator for a `TokenPool`. Validates pool and admin addresses, then calls `setRateLimitAdmin`. |
| **TransferTokenAdminRole**     | Initiates token admin role transfer in `TokenAdminRegistry`. Transfers admin to a new address. Logs that the new admin must call `acceptAdminRole` to complete the process. |
| **TransferTokens**             | Executes a CCIP cross-chain token transfer. Reads token address from JSON, chooses native or LINK fee payment, constructs CCIP message, approves tokens, estimates fees, and executes `ccipSend`. Logs message ID and tracking URL. |
| **UpdateAllowList**            | Updates a pool’s allow list by adding or removing addresses. Validates the pool supports allow list, checks all addresses are nonzero, and calls `applyAllowListUpdates`. Logs actions and results. |
| **UpdateRateLimiters**         | Updates inbound/outbound rate limiters for a pool. Reads the current rate limiter state, modifies it based on parameters (`outbound`, `inbound`, or `both`), and calls `setChainRateLimiterConfig` on the pool. |

## NPM Script Documentation

All commands are available in the file `package.json`.

| **Script**            | **Command**                                                  | **Purpose / Summary**                                        |
| --------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `deploy:token`        | `forge script DeployToken -s 'run(string,string,uint8)' 'SMTA Token' SMTAT 18 --verifier custom --verify` | Deploys a new CCIP-compatible CMTAT token with name `SMTA Token`, symbol `SMTAT`, and 18 decimals, and optionally verifies it using a custom verifier. |
| `deploy:token-pool`   | `forge script DeployBurnMintTokenPool --verifier custom --verify` | Deploys a Burn & Mint token pool for the deployed token, granting mint/burn roles to the pool, and optionally verifies the contract. |
| `claim-admin`         | `forge script ClaimAdmin`                                    | Claims the CCIP admin role for the deployed token via the `RegistryModuleOwnerCustom` contract. |
| `accept-admin`        | `forge script AcceptAdminRole`                               | Accepts the pending admin role for a token in `TokenAdminRegistry`. |
| `set-token-pool`      | `forge script SetPool`                                       | Registers a token with its pool in the `TokenAdminRegistry`. |
| `apply-chain-updates` | `forge script ApplyChainUpdates -s 'run(uint256)'`           | Applies cross-chain updates, linking local and remote pools, and optionally updating rate limiters. |
| `mint`                | `forge script MintTokens -s 'run(uint256)'`                  | Mints new tokens to the sender’s address using a configured amount. |
| `transfer`            | `forge script TransferTokens -s 'run(uint256,string,uint256)'` | Executes a cross-chain token transfer using CCIP, paying fees either in native tokens or LINK. |
| `exec`                | `sh -c 'script_name=$1; network=$2; shift 2; npm run $script_name -- --rpc-url $network $@' --` | Generic helper to execute any script on a specified network RPC URL. |
| `exec:broadcast`      | `sh -c 'script_name=$1; network=$2; shift 2; npm run $script_name -- --rpc-url $network --broadcast $@' --` | Generic helper to execute and broadcast any script on a specified network RPC URL. |
| `start-anvil:sepolia` | `source .env && anvil --fork-url $SEPOLIA_RPC`               | Starts a local Anvil node forked from Sepolia using RPC from `.env`. |
| `start-anvil:fuji`    | `source .env && anvil --fork-url $FUJI_RPC -p 8546`          | Starts a local Anvil node forked from Avalanche Fuji testnet using RPC from `.env` on port 8546. |
