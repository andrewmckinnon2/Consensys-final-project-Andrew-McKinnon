pragma solidity ^0.4.24;

library Strings {
    function concatenate(string _firstString, string _secondString) public view returns(string) {
        bytes memory firstString = bytes(_firstString);
        bytes memory secondString = bytes(_secondString);
        string memory concatenatedStrings = new string(firstString.length + secondString.length);
        bytes memory concatStrings = bytes(concatenatedStrings);

        uint k=0;
        for(uint i = 0; i < firstString.length; i++) concatStrings[k++] = firstString[i];
        for(i = 0; i < secondString.length; i++) concatStrings[k++] = secondString[i];

        return string(concatStrings);

    }
}