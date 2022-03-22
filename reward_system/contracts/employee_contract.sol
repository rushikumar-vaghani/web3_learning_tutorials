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
    uint64 present_employee_count = 0;

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
        present_employee_count++;	
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
        present_employee_count++;
    }

    function getEmployeeData(uint64 id) public view returns (Employee memory employee, bool isEmployeePresent) {
        // There is nothing like null in solidity. just check for the length of the address.
        if(employees[id].isPresent) {
        	return (employees[id], true);
        }
        // we dont have null concept in solidity so either return empty object OR revert("Not found id");
        Employee memory emptyEmployee;
        return (emptyEmployee, false);
    }

    // only owner can get all employees details
    function getAllEmployeeData() public view onlyOwner returns (Employee[] memory _employees) {
        Employee[] memory employeesData = new Employee[](present_employee_count);
        uint64 count = 0;
        for (uint64 i=0; i < auto_incremen_id; i++) {
            if(employees[i].isPresent) {
                employeesData[count++] = employees[i];
            }
        }
        return employeesData;
    }

    // Function to delete employee data. this operation only perform by owner only
    function deleteEmployeeData(uint64 id) public onlyOwner returns (bool isDeleted, string memory err_msg) {
        if(employees[id].isPresent) {
            employees[id].isPresent = false;
            return (true, "");
        }
        return (false, "Employee data already got deleted or not present");
    }

    function transferRewardAmount(uint64 sender_id, uint64 receiver_id, uint64 amount, string memory note) public returns(bool success, string memory err_msg) {
        require(sender_id != receiver_id, "sender and receiver id should not be same.");
        require(employees[sender_id].isPresent, "sender account is not present or got deactivated.");
        require(employees[receiver_id].isPresent, "receiver account is not present or got deactivated.");
        require(employees[sender_id].payable_amount >= amount, "sender does not have sufficient balance.");

        employees[sender_id].payable_amount -= amount;
        employees[receiver_id].received_reward_amount += amount;

        RewardDetail memory sender_reward_detail;
        sender_reward_detail.name = employees[sender_id].name;
        sender_reward_detail.amount = amount;
        sender_reward_detail.note = note;

        RewardDetail memory receiver_reward_detail;
        receiver_reward_detail.name = employees[receiver_id].name;
        receiver_reward_detail.amount = amount;
        receiver_reward_detail.note = note;

        send_to[sender_id].push(receiver_reward_detail);
        received_from[receiver_id].push(sender_reward_detail);

        return (true, "successfully send reward amount.");
    }
}
