// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.7;

contract testContract {
	uint256 value;

	constructor (uint256 _p) {
		value = _p;
	}

	function setP(uint256 p) payable public {
		value = p;
	}

	function setNP(uint256 p) public {
		value = p;
	}

	function getP() view public returns (uint256) {
		return value;
	}
}
