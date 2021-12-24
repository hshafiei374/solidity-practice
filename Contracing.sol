// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Contracting{
    uint256 public startDate;//timestamp
    uint16 public day;
    uint256 public amount=1000 trx;
    uint256 public deposit=100 trx;
    address payable employer;
    address payable contractor;
    address judge;
    enum status{notStarted, paid, started, ended, suspended,failed}
    status currentStatus;
    
    constructor(address payable _employer, address payable _contractor, address _judge,uint16 _day){
        currentStatus = status.notStarted;
        employer = _employer;
        contractor = _contractor;
        judge = _judge;
        day = _day;
    }
    /*
        amount of porject locked by employer
    */
    function Pay()public payable returns(string memory){
        require(currentStatus==status.notStarted, "ERROR");
        require(msg.sender==employer,"ERROR");
        require(msg.value>=amount,"ERROR");
        currentStatus = status.paid;
        return "success";
    }
    
    function Deposit() public payable returns(string memory){
        require(msg.sender==contractor,"ERROR");
        require(msg.value==deposit,"ERROR");
        require(currentStatus==status.paid,"ERROR");
        currentStatus = status.started;
        startDate = block.timestamp;
        return "success";
    }
    
    function Confirm(bool verify) public returns(string memory){
        require(msg.sender == employer, "ERROR");
        require(currentStatus == status.started, "ERROR");
        if(verify){
            currentStatus = status.ended;
        }else {
            if(block.timestamp >= (day*24*60*60)+startDate){
                 currentStatus = status.suspended;
            }else{
                return "deadline is not over";
            }
        }  
        
        return "success";
    }
    
    function Judgment(bool verify) public returns(string memory){
        require(msg.sender == judge,"ERROR");
        require(currentStatus == status.suspended,"ERROR");
        if(verify){
            currentStatus = status.ended;
        }else{
            currentStatus = status.failed;
        }
        
        return "success";
    }
    
    function WithdrawContractor() public payable returns(string memory){
        require(msg.sender == contractor, "ERROR");
        require(currentStatus == status.ended, "ERROR");
        contractor.transfer(1100 trx);
        return "success";
    }
    
    function WithdrawEmployer() public payable returns(string memory){
        require(msg.sender == employer, "ERROR");
        require(currentStatus == status.failed, "ERROR");
        employer.transfer(1100 trx);
        return "success";
    }
    
}