My project implements the contracts needed to facilitate the functionality of the marketplace project outlined in the consensys final project rubric. 
Unfortunately, I ran out of time in development of my project to implement a proper user facing UI and server for running the project and only have available my .sol contract files.
With that said, I will explain the functionality of the Marketplace and StoreOwner contracts I wrote below:

Marketplace
The Marketplace contract facilitates the creation of StoreOwners through admins (the first of which is the address that deploys the contract).
Admins can also enable other admins through the use of the addAdmins function.
The Marketplace contract implements a circuit breaker design pattern in that all of the StoreOwner contracts deployed by a Marketplace contract can be temporarily disabled through use of the lockStore function in the case of a malicious attack on the system.
Lastly, the Marketplace contract allows for the retrival of StoreOwner contracts through use of the getStore and getStoreNames functions.

StoreOwner
The StoreOwner contract facilitates a variety of functionalities that you would expect from a store owner and those expressed in the project specifications outlined by consensys.
The StoreOwner contract allows for adding store fronts through the addStore function which creates a new instance of the StoreFront struct mapped to by the name of said storeFront and accessible through a state mapping variable.
StoreOwner also implements the ability to add items to a storefronts inventory through the addInventory function and allows for addition of new items through the addItem function.
Also of note, StoreOwner facilitates purchases by consumers through the purchase function and allows the owner of a StoreOwner contract to withdraw from their balance using the withdraw function.

For those grading this project, I appologize for the lack of a UI associated with my project, hopefully you can still make sense of my contracts. I have tests for them and have compiled them in remix so there is functionality, just not a UI to go along with it.
Hope you all have fun!
