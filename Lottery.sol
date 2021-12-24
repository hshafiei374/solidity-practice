// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery{
    struct Ticket{
        uint256 id;
        uint256 created_at;
        address payable member;
        bool win;
    }
    address payable public owner;
    mapping(uint256=>Ticket) public tickets;
    uint256 public ticket_price=50 trx;
    uint256 ticket_code=0;
    uint256 public invested=0;
    uint256 public start_date;
    uint16 public day;
    bool public is_ended=false;  

    event buyTicket(address indexed addr, uint256 amount, uint256 ticket_code);
    event winner(address indexed addr, uint256 amount, uint256 ticket_code);

    constructor(uint16 _day){
        day = _day;
        owner = msg.sender;
        start_date = block.timestamp;
    }

}