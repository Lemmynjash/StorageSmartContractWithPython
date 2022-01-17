// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Storage.sol";
contract StorageFactory{
    Storage[] public simpleStorageArray;

    function createSimpleStorageContract() public{
        Storage simplestorage=new Storage();
        simpleStorageArray.push(simplestorage);
    }

    function sfstore (uint256 _simpleStorageIndex,uint256 _simpleStorageNumber) public{
        //Address
        //ABI
        //require(msg.value>.01 ether);
        Storage simpleStorage=Storage(address(simpleStorageArray[_simpleStorageIndex]));
        simpleStorage.store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        Storage simpleStorage=Storage(address(simpleStorageArray[_simpleStorageIndex]));
        return simpleStorage.retrieve();
    }
}