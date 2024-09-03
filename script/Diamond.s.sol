// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {Diamond} from "../src/Diamond.sol";
import {DiamondCutFacet} from "../src/facets/DiamondCutFacet.sol";
import {DiamondInit} from "../src/upgradeInitializers/DiamondInit.sol";
import {DiamondLoupeFacet} from "../src/facets/DiamondLoupeFacet.sol";
import {OwnershipFacet} from "../src/facets/OwnershipFacet.sol";
import {IDiamondCut} from "../src/interfaces/IDiamondCut.sol";

contract DiamondScript is Script {
    Diamond public diamond;
    DiamondCutFacet public diamondCutFacet;
    DiamondInit public diamondInit;
    string[] public facetNames = [
        'DiamondLoupeFacet',
        'OwnershipFacet'
    ];
    DiamondLoupeFacet public diamondLoupeFacet;
    OwnershipFacet public ownershipFacet;

    IDiamondCut.FacetCut[] facetCuts;
    bytes4[] private loupeFacetSelectors = [
        DiamondLoupeFacet.facets.selector,
        DiamondLoupeFacet.facetFunctionSelectors.selector,
        DiamondLoupeFacet.facetAddresses.selector,
        DiamondLoupeFacet.facetAddress.selector,
        DiamondLoupeFacet.supportsInterface.selector
    ];

    bytes4[] private ownershipFacetSelectors = [
        OwnershipFacet.transferOwnership.selector,
        OwnershipFacet.owner.selector
    ];

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        console.log("sender", vm.addr(deployerPrivateKey));
        address owner = vm.addr(deployerPrivateKey);

        diamondCutFacet = new DiamondCutFacet();

        diamond = new Diamond(owner, address(diamondCutFacet));

        diamondInit = new DiamondInit();

        diamondLoupeFacet = new DiamondLoupeFacet();
        ownershipFacet = new OwnershipFacet();
           
        facetCuts.push(IDiamondCut.FacetCut({
            facetAddress: address(diamondLoupeFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: loupeFacetSelectors
        }));

        facetCuts.push(IDiamondCut.FacetCut({
            facetAddress: address(ownershipFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: ownershipFacetSelectors
        }));

        // upgrading Diamond with facet cuts
        // then call to DiamondInit.init()
        (bool success, ) = address(diamond).call(
            abi.encodeWithSelector(
                IDiamondCut.diamondCut.selector,
                facetCuts,
                address(diamondInit),
                abi.encode(DiamondInit.init.selector)
            )
        );

        require(success, "DEPLOY :: DIAMOND_UPGRADE_ERROR");

        vm.stopBroadcast();
    }
}