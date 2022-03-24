// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.7;

contract functionTest {

	uint x;

	// view function never modify state of contract. its only for view state of contract not for modify state of contract.
	// below things will do contract state modification so we cannot use this inside view functions.
	// Writing to state variables.
	// Emitting events.
	// Creating other contracts.
	// Using selfdestruct.
	// Sending Ether via calls.
	// Calling any function not marked view or pure.
	// Using low-level calls.
	// Using inline assembly that contains certain opcodes.
	function getX() public view returns(uint) {
		return x;
	}	
}
