pragma solidity ^0.4.17;

contract Campaigns {
    
    address public manager;
    
    constructor() public {
        manager = msg.sender;
    }
}