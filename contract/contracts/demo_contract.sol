// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.7;

contract testContract {

    uint256 value;

    function setP(uint256 _n) payable public {
        value = _n;
    }

    function setNP(uint256 _n) public {
        value = _n;
    }

    function get () view public returns (uint256) {
        return value;
    }
}
