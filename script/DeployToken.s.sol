// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {HelperUtils} from "./utils/HelperUtils.s.sol"; // Utility functions for JSON parsing and chain info
import {ChainNameResolver} from "./utils/ChainNameResolver.s.sol"; // Chain name resolution utility
import {CMTATStandalone} from "../lib/cmta/contracts/deployment/CMTATStandalone.sol";
import {
    ICMTATConstructor,
    IERC1643CMTAT,
    IRuleEngine,
    ISnapshotEngine,
    IERC1643
} from "../lib/cmta/contracts/interfaces/technical/ICMTATConstructor.sol";

contract DeployToken is Script {
    function run(string memory name, string memory symbol, uint8 decimals) external {
        ChainNameResolver resolver = new ChainNameResolver();
        // Get the chain name based on the current chain ID
        string memory chainName = resolver.getChainNameSafe(block.chainid);

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address deployer = msg.sender;
        address tokenAddress;

        ICMTATConstructor.ERC20Attributes memory ERC20Attributes =
            ICMTATConstructor.ERC20Attributes(name, symbol, decimals);
        ICMTATConstructor.ExtraInformationAttributes memory extraInformationAttributes = ICMTATConstructor
            .ExtraInformationAttributes(
            "<id>", IERC1643CMTAT.DocumentInfo("<name>", "<url>", keccak256("<documentHash>")), "<information>"
        );
        ICMTATConstructor.Engine memory engines =
            ICMTATConstructor.Engine(IRuleEngine(address(0)), ISnapshotEngine(address(0)), IERC1643(address(0)));

        CMTATStandalone token =
            new CMTATStandalone(address(0), deployer, ERC20Attributes, extraInformationAttributes, engines);
        tokenAddress = address(token);
        console.log("Deployed BurnMintERC20 at:", tokenAddress);

        // Grant mint and burn roles to the deployer address
        token.grantRole(token.MINTER_ROLE(), deployer);
        token.grantRole(token.BURNER_ROLE(), deployer);
        console.log("Granted mint and burn roles to:", deployer);

        vm.stopBroadcast();

        // Prepare to write the deployed token address to a JSON file
        string memory jsonObj = "internal_key";
        string memory key = string(abi.encodePacked("deployedToken_", chainName));
        string memory finalJson = vm.serializeAddress(jsonObj, key, tokenAddress);

        // Define the output file path for the deployed token address
        string memory fileName = string(abi.encodePacked("./script/output/deployedToken_", chainName, ".json"));
        console.log("Writing deployed token address to file:", fileName);

        // Write the JSON file containing the deployed token address
        vm.writeJson(finalJson, fileName);
    }
}
