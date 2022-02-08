//SPDX-License_Identifier: MIT

pragma solidity ^0.6.0;

import "./simplestorage.sol";

contract StorageFactory is simpleStorage {
    simpleStorage[] public simpleStorageArray;
    function createSimpleStorageContract() public {
        simpleStorage SimpleStorage = new simpleStorage();
        simpleStorageArray.push(SimpleStorage);
    }

    function sfStore(uint256 _index, uint256 _simpleStorageNum) public{
        simpleStorage SimpleStorage = simpleStorage(address(simpleStorageArray[_index]));
        SimpleStorage.store(_simpleStorageNum);
    }
    function sfGet(uint256 _index) public view returns(uint256){
        simpleStorage SimpleStorage = simpleStorage(address(simpleStorageArray[_index]));
        return SimpleStorage.retrieve();
    }
}