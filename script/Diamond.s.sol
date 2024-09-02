// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {Diamond} from "../src/Diamond.sol";
import {DiamondCutFacet} from "../src/facets/DiamondCutFacet.sol";
import {DiamondInit} from "../src/upgradeInitializers/DiamondInit.sol";
import {DiamondLoupeFacet} from "../src/facets/DiamondLoupeFacet.sol";
import {OwnershipFacet} from "../src/facets/OwnershipFacet.sol";
import {IDiamondCut} from "../src/interfaces/IDiamondCut.sol";
import "./lib/HelpContract.sol";

contract DiamondScript is Script, HelperContract {
    Diamond public diamond;
    DiamondCutFacet public diamondCutFacet;
    DiamondInit public diamondInit;
    string[] public facetNames = [
        'DiamondLoupeFacet',
        'OwnershipFacet'
    ];
    DiamondLoupeFacet public diamondLoupeFacet;
    OwnershipFacet public ownershipFacet;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        console.log("sender", vm.addr(deployerPrivateKey));
        address owner = vm.addr(deployerPrivateKey);

        diamondCutFacet = new DiamondCutFacet();

        diamondInit = new DiamondInit();

        diamondLoupeFacet = new DiamondLoupeFacet();
        ownershipFacet = new OwnershipFacet();

        FacetCut[] memory cut = new FacetCut[](2);
        cut[0] = (
            FacetCut({
            facetAddress: address(diamondLoupeFacet),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );
        cut[1] = (
            FacetCut({
            facetAddress: address(ownershipFacet),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("OwnershipFacet")
            })
        );
        diamond = new Diamond(owner, address(diamondCutFacet));
        
        vm.stopBroadcast();
    }
}