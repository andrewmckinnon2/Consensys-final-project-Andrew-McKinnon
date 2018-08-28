pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MarketPlace.sol";
import "../contracts/StoreOwner.sol";

contract TestMarketPlace {

    //test addAdmin functionality
    function testAddAdmin() public {
        MarketPlace marketPlace = MarketPlace(DeployedAddresses.MarketPlace());

        marketPlace.addAdmin(this);
        assert.equal(marketPlace.admins[this], true);
    }

    //test addStoreOwner functionality
    function testaddStoreOwner() public {
        MarketPlace marketPlace = MarketPlace(DeployedAddresses.MarketPlace());

        marketPlace.addStoreOwner(this);

        assert.equal(marketPlace.storeOwners[this].owner, this);
    }

    //test getStore functionality
    function testGetStore() public {
        MarketPlace marketPlace = MarketPlace(DeployedAddresses.MarketPlace());

        marketPlace.addStoreOwner(this);

        assert.equal(address(marketPlace.storeOwnerAddresses[this]), address(marketPlace.storeOwners[this]));

    }

    //test lockStore functionality
    function testLockStore() public {
        MarketPlace marketPlace = MarketPlace(DeployedAddresses.MarketPlace());
        marketPlace.addStoreOwner(this);

        marketPlace.lockStore();
        assert.equal(marketPlace.storeOwners[this].lockdown, true);
    }

    //test unlockStore functionality
    function testUnlockStore() public {
        MarketPlace marketPlace = MarketPlace(DeployedAddresses.MarketPlace());
        marketPlace.addStoreOwner(this);

        marketPlace.unlockMStore();
        assert.equal(marketPlace.storeOwners[this].lockdown, true);
    }
}