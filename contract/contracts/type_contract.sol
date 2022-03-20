// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.7;


contract typeTest {
	uint x;
	uint constant XCONS = 15; // constant value will not be modify and value assign to it at compile time.
	uint immutable ximmutable; // immutable value also not be modify but we can assign once at runtime(constructor).
	constructor(uint xi) public{
		ximmutable = xi;
	}


	byte b;
	bool c;
	
	address owner;

	struct structTest {
		byte b;
		bool c;
		address owner;	
	}

	structTest st;

	// when we mentioned public keyword for data types 
	// compiler will create default getter for this.
	// function getArray(uint index) public returns (uint) { return array[index]; }. this is true for all datatypes
	// but incase of array compile create getter which return only once member not whole array because of gas limit.
	uint[] public array;

	// to access complete array we can write down below
        // memory is keyword which is mendatory when we do return whole array
	function getWholeArray() public returns (uint[] memory) {
		return array;
	}

	mapping (uint => bool) public map;
}
