//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract DebuggerExample {
    uint public myUint;

    function setMyUint(uint _myuint) public {
        myUint = _myuint;
    }
}