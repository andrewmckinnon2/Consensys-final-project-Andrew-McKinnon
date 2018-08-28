pragma solidity ^0.4.24;
import "./Strings.sol";

/**@title Store Owner */
contract StoreOwner {
    address public owner;
    address public marketPlace;
    mapping(string => StoreFront) public storeFronts;
    string[] storeNames;
    uint balance;
    bool lockdown;

    struct StoreFront {
        string name;
        Item[10] inventory;
        uint revenue;
        uint inventoryCount;
    }

    struct Item {
        string name;
        uint quantity;
        uint price;
        uint placeInItemsArray;
    }

    //verifies owner is the caller of function
    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    //verifies that balance is less than amount passed (used in withdraw function)
    modifier verifyBalance(uint _amount) {
        require(balance <= _amount);
        _;
    }

    //verifies that msg.value is enough for purchasing an item
    modifier verifyEther(uint _quantity, uint _itemNumber, string _storeName) {
        uint cost = storeFronts[_storeName].inventory[_itemNumber].price * _itemNumber;
        require(msg.value >= cost);
        _;
    }

    //Implementation of circuitBreaker design pattern, ensures that all functions that send ether or modify state are toggleable
    modifier circuitBreaker() {
        require(!lockdown);
        _;
    }

    //Verifies that the caller of a function is the marketPlace contract that was used in creation of this contract
    modifier verifyMarketPlace() {
        require(msg.sender == marketPlace);
        _;
    }

    //constructor specifies owner, Marketplace contract used to create contract, and sets lockdown to false
    constructor (address _owner, address _marketPlace) public {
        owner = _owner;
        marketPlace = _marketPlace;
        lockdown = false;
    }

    /** @dev adds a new store owned by this contracts owner.
      * @param _name name of the store
      */
    function addStore(string _name)
        private
        isOwner()
        circuitBreaker()
    {
        Item[10] _inventory;
        storeFronts[_name] = StoreFront({
            name: _name,
            inventory: _inventory,
            revenue: 0,
            inventoryCount: 0
        });
        storeNames.push(_name);
    }

    /**@dev sends specified amount to owner of store and decreases their balance 
    * @param amount amount to be withdrawn by user
    */

    function withdraw(uint amount)
        private
        isOwner()
        verifyBalance(amount)
        circuitBreaker()
    {
        if(msg.sender.send(amount)){
            balance -= amount;
        }
    } 

    /**@dev adds an inventory item to the specified store
    * @param _storeName specifies the store who's inventory is being modified
    * @param _itemNumber specifies the numerical id associated with the inventory item to be increased
    * @param _amountToAdd specifies the quantity by which to increase the inventory item
    */
    function addInventory(string _storeName, uint _itemNumber, uint _amountToAdd)
        private
        isOwner()
        circuitBreaker()
    {
        storeFronts[_storeName].inventory[_itemNumber].quantity += _amountToAdd;
    }

    /**@dev changes price of the inventory item specified
    * @param _storeName specifies the store at which the item who's price is being changed is stored
    * @param _itemNumber specifies the numerical id associated with the inventory item to be modified
    * @param _newPrice specifies new price for the targeted item
    */
    function changePrice(string _storeName, uint _itemNumber, uint _newPrice)
        private
        isOwner()
        circuitBreaker()
    {
        storeFronts[_storeName].inventory[_itemNumber].price = _newPrice;
    }

    /**@dev perform a purchase of the item specified
    * @param _storeName specifies the store where the targeted item is located
    * @param _itemNumber specifies the numberical id associated with the inventory item being purchased
    * @param _quantity specifies the quantity of items to be purchased
    */
    function purchase(string _storeName, uint _itemNumber, uint _quantity)
        public
        payable
        verifyEther(_quantity, _itemNumber, _storeName)
        verifyMarketPlace()
    {
        uint cost = storeFronts[_storeName].inventory[_itemNumber].price * _itemNumber;
        balance += cost;
        storeFronts[_storeName].revenue += cost;
    }

    function addItem(string _storeName, string _name, uint _quantity, uint _price)
        public
        isOwner()
        returns (bool)
    {
        if(storeFronts[_storeName].inventoryCount < 11) {
            uint _placeInArray = storeFronts[_storeName].inventoryCount + 1;
            storeFronts[_storeName].inventoryCount++;
            uint arrayPos = storeFronts[_storeName].inventoryCount - 1;
            storeFronts[_storeName].inventory[arrayPos] = Item({
                name: _name,
                quantity: _quantity,
                price: _price,
                placeInItemsArray: _placeInArray
            });
            return true;
        }else {
            return false;
        }
    }

    /**@dev retrieves inventory ids for a store; first 0 indicates no item
    * @param _storeName specifies the store name who's inventory will be retrieved
    * @return uint[10] returns an array of inventory ids
    */
    function getInventoryNums(string _storeName)
        public
        view
        returns (uint[10])
    {
        uint[10] memory inventory;
        for(uint i = 0; i<10; i++){
            inventory[i] = storeFronts[_storeName].inventory[i].placeInItemsArray;
        }
        return inventory;
    }

    /**@dev retrieves the names of items in a store in the form of a single string with names comma separated
    * @param _storeName specifies the targeted store
    * @return string returns string containing the names of items in the targeted store as with comma separation
    */
    function getItemNames(string _storeName)
        public
        view
        returns (string)
    {
        string memory inventory;
        for(uint i = 0; i<10; i++) {
            inventory = Strings.concatenate(Strings.concatenate(inventory, ","),storeFronts[_storeName].inventory[i].name);
        }

        return inventory;
    }

    /**@dev gets the revenue from the specified store
    * @param _storeName specifies the store targeted
    * @return uint returns an integer representing the revenue associated with the specified store
    */
    function getRevenue(string _storeName)
        public
        returns (uint)
    {
        return storeFronts[_storeName].revenue;
    }

    /**@dev provides a function to lock contract in the event of an attack (circuit breaker design pattern) */
    function lockDown()
        public 
        verifyMarketPlace()
    {
        lockdown = true;
    }

    /**@dev provies a function to end contract lock (circuit breaker design pattern) */
    function endLockDown() 
        public
        verifyMarketPlace()
    {
        lockdown = false;
    }


    /**@dev retrieves store names of all storefronts stored in contract
    *@return string returns a string containing all storefront names in comma separated fashion
    */
    function getStoreNames()
        public
        view
        returns (string)
    {
        string memory names;
        for(uint i = 0; i < storeNames.length; i++){
            names = Strings.concatenate(names, storeNames[i]);
        }
        return names;
    }

    /**@dev retrieves the balance of this StoreOwner
    *  @return uint returns the balance of this StoreOwner
    */
    function getBalance()
        public
        view
        returns (uint)
    {
        return blance;
    }
        
}