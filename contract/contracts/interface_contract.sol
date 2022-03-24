// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.7;


// interface : all function within that has only declaration not a defination and defination must be define derive contract.
// They cannot inherit from other contracts, but they can inherit from other interfaces.
// All declared functions must be external in the interface, even if they are public in the contract.
// They cannot declare a constructor.
// They cannot declare state variables.
// They cannot declare modifiers.
interface interfaceTest {

	// we can declare enum or structure here.
	enum AreaTye {Circle, Square, Cube}
	struct Data {
		string name;
		uint age;
		string email; 
	}

	// all function should have external keyword so that derive contract can override those functions.
	function calculate_area() external returns (uint area);
}

interface circleTest is interfaceTest {
	function calculate_circle_area() external returns(uint area);
}

contract derivedInterfaceTest is interfaceTest {
	uint x;
	uint y;

	// we need override keyword while implementing interface functions
	function calculate_area() public override returns (uint area) {
		return x*y;
	}

	// we can access types define (enum, struct) inside struct using interfaceTest.Data or interfaceTest.AreaTyep
}


