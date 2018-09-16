pragma solidity ^0.4.19;

import "./SafeMath.sol";

contract Charity{
    using SafeMath for uint;
    
    address private owner;
    uint public totalDonations;
    uint public multipurposeBalance;
    uint public missionCounter;
    
    modifier isOwner{
        require(msg.sender == owner);
        _;
    }
    
    event Donated(address from, uint amount, string organization);
    
    constructor() public{
        owner = msg.sender;
    }
    
    mapping(address=>uint8) donors;
    
    // @dev struct to store collection of donations given to one organization
    // and store its Impact
    struct Mission{
        //uint impactId;
        address[] givers;
        //mapping(address=>uint8) impacters;
        uint amount;
        string organization;
        uint date;
    }
    
    mapping(string => Mission) missions;
    //Impact[] public impacts;
    
    // @dev return total donations
    /*function getTotalDonations() public view returns(uint){
        return totalDonations;
    }*/
    
    //@dev fallback for any donation received, used for multipurpose balance
    function() payable public{
        multipurposeBalance = multipurposeBalance.add(msg.value);
        totalDonations = totalDonations.add(msg.value);
        donors[msg.sender] = 1;
        emit Donated(msg.sender, msg.value, "fallback");
    }
    
    function createImpact(string organization) isOwner private{
        Mission memory mission;
        mission.organization = organization;
        missions[organization] = mission;
        missionCounter++;
    }
    
    function donate(address from, uint amount, string org) payable public{
        require(from == msg.sender);
        require(amount > 0);
        donors[msg.sender] = 1;
        //impactIdCounter++;
        Mission storage mission = missions[org];
        mission.amount = mission.amount.add(amount);
        mission.givers.push(from);
        mission.date = now;
    }
    
    function giveBack(address to, uint amount, string org) isOwner public{
        require(amount < totalDonations);
    }
    
    
}
