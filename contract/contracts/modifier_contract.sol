// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.7;

contract modifierTest {
 	
	address payable owner;
	uint value;

        constructor() public { 
   		owner = payable(msg.sender); 
	}

	modifier ownedBy() {
		require (msg.sender == owner, "Only owner can call this function.");
		_; // this _; will replace by function code where this modifier used. in below example it will replace by {value=v}
	}

	function setValue(uint v) public ownedBy {
		value = v;
	}
}

// we can derived multiple contract by specifying , ( ... is modifierTest, xTest, yTest_)
contract derivedTest is modifierTest {
	
	uint xval;

	function setX(uint x) public ownedBy {
		xval = x;
	}
}
