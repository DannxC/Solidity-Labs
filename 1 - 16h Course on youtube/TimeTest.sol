// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

contract timeTest {
    uint256 start;
    uint256 maxTime;
    uint256 actualTime;

    constructor(uint256 _maxTime) {
        start = block.timestamp;
        maxTime = _maxTime;
        end = start + _maxTime;
    }

    function actualTime() public view returns(uint256) {
        require(block.timestamp - start < maxTime);
        return block.timestamp;
    }
}