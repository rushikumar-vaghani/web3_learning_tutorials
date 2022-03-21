// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.7;

contract Employees {

        struct reward_detail {
                string name;
                uint64 amount;
                string note;
        }

        struct employee {
                uint64 id;
                string name;
                uint64 payable_amount;
                uint64 received_reward_amount;
                string designation;
                reward_detail[] received_from;
                reward_detail[] send_to;
        }

        constructor() public {

        }
}
  
