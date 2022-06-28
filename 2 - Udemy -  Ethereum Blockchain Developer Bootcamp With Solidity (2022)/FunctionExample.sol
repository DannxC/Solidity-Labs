//SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

contract FunctionsExample {

    mapping(address => uint) public balanceReceived;

    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function getOwner() public view returns(address) {
        return owner;
    }

    function convertWeiToEther(uint _amountInWei) public pure returns(uint) {
        return _amountInWei / 1 ether;
    }

    function destroySmartContract() public {
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(owner);
    }

    function receiveMoney() public payable {
        assert(msg.value == uint(msg.value));
        balanceReceived[msg.sender] += uint(msg.value);
        assert(balanceReceived[msg.sender] >= uint(msg.value));
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        require(_amount <= balanceReceived[msg.sender], "You don't have enought ether!");
        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }

    receive() external payable {        
        receiveMoney();
    }
}