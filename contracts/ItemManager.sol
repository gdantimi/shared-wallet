// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./SupplyChainModel.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract ItemManager is Ownable {
    mapping(uint => SupplyChainModel.Item) public items;
    uint index;

    function add(string memory id, uint priceInWei) public onlyOwner {
        ItemContract item = new ItemContract(address(this), priceInWei, index);
        items[index].item = item;
        items[index].id = id;
        SupplyChainModel.Status newStatus = SupplyChainModel.Status.Created;
        items[index].status = newStatus;
        index++;
        emit SupplyChainModel.StatusEvent(index, newStatus, address(item));
    }

    function pay(uint indexToPay) public payable {
        ItemContract item = items[indexToPay].item;
        require(item.priceInWei() > msg.value, "Not fully paid");
        require(items[indexToPay].status == SupplyChainModel.Status.Created, "Item has been already paid or delivered");
        SupplyChainModel.Status newStatus = SupplyChainModel.Status.Paid;
        items[indexToPay].status = newStatus;
        emit SupplyChainModel.StatusEvent(indexToPay, newStatus, address(item));
    }

    function deliver(uint itemIndex) public onlyOwner {
        require(items[itemIndex].status == SupplyChainModel.Status.Paid, "Item has been not been paid");
        SupplyChainModel.Status newStatus = SupplyChainModel.Status.Delivered;
        items[itemIndex].status = newStatus;
        ItemContract item = items[itemIndex].item;
        emit SupplyChainModel.StatusEvent(itemIndex, newStatus, address(item));
    }
}