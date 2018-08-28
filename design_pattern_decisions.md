My project is organized into two two main contracts - Marketplace and StoreOwner.
The MarketPlace contract authorizes administrators who then can create StoreOwner contracts that are tied to an ethereum address that is the owner of the contract.
Admins can also authorize new admins with the original contract deployer acting as the initial admin of Marketplace.

The StoreOwner contract facilitates transactions between a store owner and a consumer with functions for adding inventory, opening store fronts, withdrawls and purchases.
I've also implemented the circuit breaker design pattern where by a Marketplace contract can place a lock on all of the StoreOwner contracts created by it by calling the lockStore function which calls the lockDown function for every StoreOwner associated with the Marketplace contract.

Additionally there are two test files in the test folder called TestMarketPlace and TestStoreOwner which implement tests for the functionality of MarketPlace and StoreOwner respectively.

