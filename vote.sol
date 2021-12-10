// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Vote{
    //state variable
    address public owner;
    enum states{NotStarted,Started,Finished}
    states public currentState = states.NotStarted;
    struct candidate{
        uint8 id;
        string name;
        uint voteCount;
    }
    mapping(uint8=>candidate) public candidates;
    mapping(address=>bool) public voters;
    uint8 public candidateNumber=0;
    //error functions
    //modifiers
    modifier inState(states _state){
        if(_state!=currentState){
            revert("Invalid state!");
        }
        _;//else run function
    }
    modifier onlyOwner(){
        require(msg.sender==owner,  "only owner can call this function!");
        _;//else run function
    }
    modifier alreadyVoted(){
        if(voters[msg.sender]==true){
            revert("the voter has already voted!");
        }
        _;
    }
    modifier candidateNotFound(uint8 id){
        if(id>candidateNumber-1){
            revert("candidate not found!");
        }
        _;
    }
    //events
    event Winner(uint8 winnerID, uint winnerVote);
    //constructor
    constructor(){
        owner = msg.sender;//who deployed this ontract
    }
    //functions
    function changeState(uint8 state) public onlyOwner{
        if(state == 0){
            currentState = states.NotStarted;
        }
        if(state == 1){
            currentState = states.Started;
        }
        else{
            currentState = states.Finished;
        }
    }
    function addCandidate(string memory name) public onlyOwner inState(states.NotStarted) returns(string memory message){
        candidates[candidateNumber] = candidate(candidateNumber, name, 0);
        candidateNumber++;
        message = "add candidate is successfully";
        return message;
    }
    function vote(uint8 _id) public inState(states.Started) alreadyVoted candidateNotFound(_id) returns(string memory message){
        candidates[_id].voteCount++;
        voters[msg.sender] = true;
        message = "your vote is successfully registered";
        return message;
    }
    function getFinalWinner() public inState(states.Finished){
        uint8 winnerId;
        uint winnerVote;
        for(uint8 i=0; i<candidateNumber; i++){
            if(candidates[i].voteCount>winnerVote){
                winnerId = i;
                winnerVote = candidates[i].voteCount;
            }
        }

        emit Winner(winnerId, winnerVote);

    }
}
