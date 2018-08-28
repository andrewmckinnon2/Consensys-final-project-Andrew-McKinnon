pragma solidity ^0.4.24;
import "./StoreOwner.sol";
import "./Strings.sol";

/**@title Marketplace */
contract Marketplace {
    mapping(address => bool) public admins;
    mapping(address => StoreOwner) public storeOwners;
    address[] public storeOwnerAddresses;

    //verifies that caller of a function is an admin of marketplace
    modifier verifyAdmin() {
        require(admins[msg.sender], "user is not an administrator");
        _;
    }
    
    constructor () public {
        admins[msg.sender] = true;
    }

    /**@dev add a new admin to Marketplace
    * @param addr specifies the address that is to be added as a new admin
    */
    function addAdmin(address addr) 
        public
        verifyAdmin()
    {
        admins[addr] = true;
    }

    /**@dev adds a new storeOwner and creates a new StoreOwner contract 
    * @param addr specifies the address of the owner of the newly created StoreOwner
    */
    function addStoreOwner(address addr)
        public
        verifyAdmin()
    {
        storeOwners[addr] = new StoreOwner(addr, this);
        storeOwnerAddresses.push(addr);
    }

    /**@dev gets the StoreOwner contract associated with the address specified
    * @param addr specifies the address who's StoreOwner contract is to be retrieved
    */
    function getStore(address addr)
        public
        returns (address)
    {
        return storeOwners[addr];
    }

    /**@dev gets all store names stored within storeOwner contracts held in this contract
    * @return string returns a string with all names of stores in contract in form of comma separated string 
    */
    function getStoreNames() 
        public
        returns (string)
    {
        string memory listOfNames;
        for(uint i = 0; i < storeOwnerAddresses.length; i++) {
            listOfNames = Strings.concatenate(listOfNames, storeOwners[storeOwnerAddresses[i]].getStoreNames());
        }
        
        return listOfNames;
    }
    
    /**@dev implements the circuit breaker design pattern by calling lockDown on all storeOwner contracts sotred in Marketplace*/
    function lockStore() 
        public
        verifyAdmin()
    {
        for(uint i = 0; i<storeOwnerAddresses.length; i++) {
            storeOwners[storeOwnerAddresses[i]].lockDown();
        }
    }

    /**@dev implements other portion of circuit breaker design pattern by allowing admins to unlock storeOwner contracts*/
    function unlockStore()
        public
        verifyAdmin()
    {
        for(uint i = 0; i<storeOwnerAddresses.length; i++) {
            storeOwners[storeOwnerAddresses[i]].lockDown();
        }
    }
}