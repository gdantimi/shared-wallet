// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./ItemManager.sol";

contract ItemContract {
    uint public priceInWei;
    bool public isPaid;
    uint public index;
    address itemManagerContractAddress;

    constructor(address _itemManagerContractAddress, uint _priceInWei, uint _index){
        priceInWei = _priceInWei;
        index = _index;
        itemManagerContractAddress = _itemManagerContractAddress;
    }

    receive() external payable {
        require(msg.value == priceInWei,  "Partial payments are not supported");
        require(!isPaid,  "Item is already paid");
        (bool success, ) = itemManagerContractAddress.call{value: msg.value}(abi.encodeWithSignature("pay(uint256)", index));
        require(success, "Delivery did not work");
    }
    
}
