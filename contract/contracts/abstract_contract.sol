// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.7;

// abstract: when few/all of functions are only declare and define in derive class called abstract contract.
// how to define abstract contract: we have to put abstract keyword before contract
abstract contract abstractTest {

	uint area;

	// all function declaration must be virtual
	function calculate_area(uint xv, uint yv) external virtual;

	function get_area() public returns (uint area) {
		return area;
	}
}

contract deriveAbstractTest is abstractTest {

	// in case if we want to override same function again in further inheriated contract we have to put virtual
	// ex. function calculate_area(uint xv, uint yv) public virtual override {}
	function calculate_area(uint xv, uint yv) public override {
		area = xv*yv;
	}

	// we can access base/chile class variable directly by passing contract_name.function_name()
	function get_abstract_area() public returns (uint area) {
		return abstractTest.get_area();
	}
}
