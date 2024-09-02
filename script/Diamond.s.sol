// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {Diamond} from "../src/Diamond.sol";
import {DiamondCutFacet} from "../src/facets/DiamondCutFacet.sol";
import {DiamondInit} from "../src/upgradeInitializers/DiamondInit.sol";

contract DiamondScript is Script {
    Diamond public diamond;
    DiamondCutFacet public diamondCutFacet;
    DiamondInit public diamondInit;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        console.log("sender", vm.addr(deployerPrivateKey));
        address owner = vm.addr(deployerPrivateKey);

        diamondCutFacet = new DiamondCutFacet();

        diamond = new Diamond(owner, address(diamondCutFacet));

        diamondInit = new DiamondInit();

        vm.stopBroadcast();
    }
}