// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./ItemContract.sol";

library SupplyChainModel {
    event StatusEvent(uint itemIndex, Status status, address itemAddress);
    
    enum Status {Created, Paid, Delivered}

    struct Item {
        string id;
        ItemContract item;
        Status status;
    } 

}