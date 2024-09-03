## Diamond pattern

Based on Nick Mudge's diamond 3 hardhat, convert it to run with foundry forge

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

### deploy diamond pattern contracts
```
forge script script/Diamond.s.sol:DiamondScript --rpc-url localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

#### keystore encryption
```
cast wallet import --interactive testAccount
```
use the keystore to deploy
```
forge script script/Diamond.s.sol:DiamondScript --rpc-url localhost:8545 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --account testAccount --broadcast
```