// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.7;

contract constructorTest {
	uint immutable a;

	// Prior to version 0.4.22, constructors were defined as functions with the same name
	// Prior to version 0.7.0, you had to specify the visibility of constructors as either internal or public.
	constructor(uint _a) public {
		a = _a;
	}
}


contract deriveConstructorTest is constructorTest(1) {

	// if we do not create any constructor it will create default constructor as define below
	constructor() public {}	
}
