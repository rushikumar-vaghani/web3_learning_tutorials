// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.7;
pragma experimental ABIEncoderV2;

// we can use default available ownable solidity
// import "@openzeppelin/contracts/access/Ownable.sol"


contract Employees {

        uint64 DEFAULT_REWARD_AMOUNT = 1000;
        struct RewardDetail {
                string name;
                uint64 amount;
                string note;
        }

        struct Employee {
                uint64 id;
                string name;
                uint64 payable_amount;
                uint64 received_reward_amount;
                string designation;
		bool isPresent;
		// TODO: add address field and verify before any operation like SendReward.
		// address employe_address;
        }

        address owner;
        uint64 auto_incremen_id = 0;
        mapping (uint64 => Employee) employees;
	mapping (uint64 => RewardDetail[]) received_from;
	mapping (uint64 => RewardDetail[]) send_to;

        constructor() public {
                owner = msg.sender;
        }

        modifier onlyOwner() {
                require(owner == msg.sender, "This operation only performed by owner");
                _;
        }

	// only owner allow to add new employee details.
        // overload function with different param. in case if owner add reward amount otherwise set to default one
        function addEmployeeData(string memory name, uint64 payable_amount, string memory designation) public onlyOwner {
		// need mutex before we increment id 
		Employee memory employee;
		employee.id = auto_incremen_id++;
		employee.name = name;
		employee.payable_amount = payable_amount;
		employee.received_reward_amount = 0;
		employee.designation = designation;
		employee.isPresent = true;
		employees[employee.id] = employee;
				
        }

        function addEmployeeData(string memory name, string memory designation) public onlyOwner {
		// we can also perform same operation as below
		// Employee memory employee = Employee(auto_incremen_id++, name, DEFAULT_REWARD_AMOUNT, 0, designation, true);
		Employee memory employee;
                employee.id = auto_incremen_id++;
                employee.name = name;
                employee.payable_amount = DEFAULT_REWARD_AMOUNT;
                employee.received_reward_amount = 0;
                employee.designation = designation;
		employee.isPresent = true;
                employees[employee.id] = employee;
        }

        function getEmployeeData(uint64 id) public view returns (Employee memory employee, bool isEmployeePresent) {
		// There is nothing like null in solidity. just check for the length of the address.
 		if(employees[id].isPresent) {
			return (employees[id], true);
		}
		// we dont have null concept in solidity so either return empty object OR revert("Not found id");
		Employee memory employee;
		return (employee, false);
        }

	// only owner can get all employees details
	function getAllEmployeeData() public view onlyOwner returns (Employee[] memory employees) {
		return employees;
	}


}

