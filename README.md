### Technical Specifications

- Deploy a CMTAT token on two testnet blockchains (e.g., Sepolia and Avalanche Fuji).
- Bridge tokens between them using Chainlink CCIP.
- The CMTAT token already implements the Cross-Chain Token standard.
- Provide guidelines and details for the main steps involved.

### Repository Preparation

**Note:** The default project layout in `foundry.toml` has been overridden to `src = "lib/cmta/contracts"`. To build the project, follow these steps:

1.  Clone the repository.
2.  Run `forge install` and `npm install`.
3.  Navigate to the `lib/cmta` directory and run `npm install` and `git submodule update`.
4.  Run `forge build`.

### Prerequisites

This guide assumes you are already familiar with Solidity, Foundry, and Chainlink CCIP. You should also have native tokens (e.g., ETH on Sepolia and AVAX on Fuji) and LINK tokens on both chains.

### Main Steps

0.  **Optional:** Start local Anvil servers for both chains: `npm run start-anvil:sepolia` and `npm run start-anvil:fuji`.
1.  Deploy the token on both chains: `npm run exec:broadcast -- deploy:token <sepolia/fuji>`
2.  Deploy the token pool on both chains: `npm run exec:broadcast -- deploy:token-pool <sepolia|fuji>`
3.  Claim the admin role on both chains: `npm run exec:broadcast -- claim-admin <sepolia|fuji>`
4.  Accept the admin role on both chains: `npm run exec:broadcast -- accept-admin <sepolia|fuji>`
5.  Set the token pool on both chains: `npm run exec:broadcast -- set-token-pool <sepolia|fuji>`
6.  Apply chain updates on both chains: `npm run exec:broadcast -- apply-chain-updates <sepolia|fuji> <destinationChainSelector>`
7.  Mint tokens on a chain: `npm run exec:broadcast -- mint <sepolia|fuji> <amount>`
8.  Transfer tokens between chains: `npm run exec:broadcast -- transfer <sepolia|fuji> <amount> <native|link> <destinationChainSelector>`

### Quick Overview of Each Step

0.  Before broadcasting any transactions, it is a best practice to run the scripts locally to ensure everything works as expected. You can start two forked Anvil servers (one for Sepolia and one for Fuji) for local testing.
1.  First, deploy the `CMTATStandalone` token contract on both chains. We use this version because it includes the `getCCIPAdmin` function, which simplifies the admin claiming process.
2.  After deploying the token, deploy the `BurnMintTokenPool` contract on both chains.
3.  Claim the admin role for the token pool. This will allow you to configure the necessary settings for bridging.
4.  Complete the process by accepting the admin role.
5.  Wire up the token pool to the token contract by setting the pool address on the token contract.
6.  Link the chains by applying the chain updates on both token pools.
7.  Mint new tokens to an address.
8.  Bridge the tokens from a source chain to a destination chain.

### Artifacts

- [Deployments](./script/output)
- [Sepolia to Fuji Transfer](https://ccip.chain.link/#/side-drawer/msg/bea53245339f8907c2104a11ded786428980968a1a639cd1d87d9ae464683f31) | [Fuji to Sepolia Transfer](https://ccip.chain.link/#/side-drawer/msg/dfb374fef50749b0bc86784e097ecc9547c5145ddfb8f9d96f1da3024abfcd04)

### Additional Resources

A detailed bridging tutorial from Chainlink can be found [here](./GUIDELINE.md).
