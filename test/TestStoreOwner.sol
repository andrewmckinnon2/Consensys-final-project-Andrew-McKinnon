pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MarketPlace.sol";
import "../contracts/StoreOwner.sol";

contract TestStoreOwner {
    
    //ensure that storeOwner adds a store correctly
    function testAddStore() public {
        MarketPlace marketPlace = MarketPlace(DeployedAddresses.MarketPlace());

        marketPlace.addStoreOwner(this);
        marketPlace.storeOwners[this].addStore("My store");
        string expected = "My store";
        assert.equals(marketPlace.storeOwners[this].storeFronts[expected].name, expected);
    }

    //Test if addItem function works as expected
    function testAddItem() public {
        MarketPlace marketPlace = MarketPlace(DeployedAddresses.MarketPlace());

        marketPlace.addStoreOwner(this);
        marketPlace.storeOwners[this].addStore("My store");
        string storeName = "My store";

        StoreOwner testStore = marketPlace.storeOwners[this];
        //Add a new item called 10 of a new item called "pool noodle" at a price of 5 wei each
        testStore.addItem("My store", "pool noodle", 10, 5);

        assert.equals(testStore.storeFronts[storeName].name, "pool noodle");
    }

    //Test if withdrawl changes balance as expected
    function testWithdraw() public {
        MarketPlace marketPlace = MaretPlace(DeployedAddress.MarketPlace());

        marketPlace.addStoreOwner(this);
        marketPlace.StoreOwners[this].addStore("My store");
        string storeName = "My store";

        StoreOwner testStore = marketPlace.storeOwners[this];
        //Add a new item called 10 of a new item called "pool noodle" at a price of 5 wei each
        testStore.addItem("My store", "pool noodle", 10, 5);
        //make a call to testStore to purchase one pool noodle item
        testStore.purchase(5)(storeName, 0, 1);

        uint expected = 5;

        assert.equals(testStore.getBalance(), expected);
    }

    //Test if lock (i.e. circuit breaker) function works correctly
    function testLock() public {
        MarketPlace marketPlace = MaretPlace(DeployedAddress.MarketPlace());

        marketPlace.addStoreOwner(this);
        marketPlace.StoreOwners[this].addStore("My store");

        StoreOwner testStore = marketPlace.storeOwners[this];

        testStore.lockDown();
        assert.equals(testStore.lockdown, true);
    }

    //test if unlock (i.e. circuit breaker) functionality works correctly
    function testUnlock() public {
        MarketPlace marketPlace = MaretPlace(DeployedAddress.MarketPlace());

        marketPlace.addStoreOwner(this);
        marketPlace.StoreOwners[this].addStore("My store");

        StoreOwner testStore = marketPlace.storeOwners[this];

        testStore.lockDown();
        testStore.endLockDown();
        assert.equals(testStore.lockdown, false);
    }

}