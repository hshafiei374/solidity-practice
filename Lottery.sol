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
        owner = payable(msg.sender);
        start_date = block.timestamp;
    }

    function buy_ticket() public payable returns(uint256){
        require(msg.value == ticket_price);
        require(block.timestamp < start_date + (day*86400));
        owner.transfer(msg.value/5);
        ticket_code++;
        invested+=(msg.value*95)/100;
        tickets[ticket_code] = Ticket(ticket_code, block.timestamp, payable(msg.sender), false);
        emit buyTicket(msg.sender, msg.value, ticket_code);
        return ticket_code;
     }

     function start_lottery() public{
         require(msg.sender == owner);
         require(block.timestamp > start_date + (day*86400));
         require(is_ended == false);
         uint256 winnerTicketCode = random(ticket_code);
         tickets[winnerTicketCode].win = true;
         tickets[winnerTicketCode].member.transfer(invested);
         is_ended = true;
         emit winner(tickets[winnerTicketCode].member, invested, winnerTicketCode);
     }

     function random(uint256 count) private view returns(uint256){
        uint rand =  uint( keccak256( abi.encodePacked(block.timestamp,block.difficulty)  ) ) % count;
        return rand;
     }

}