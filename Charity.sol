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
    event Given(address to, uint amount, string organization);
    
    constructor() public{
        owner = msg.sender;
    }
    
    mapping(address=>uint8) donors;
    
    // @dev struct to store collection of donations given to one organization
    // and store its Impact
    struct Mission{
        address[] contributors;
        uint contributorCount;
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
    
    //@dev allows owner to create new mission with org name
    function createImpact(string organization) isOwner private{
        Mission memory mission;
        mission.organization = organization;
        missions[organization] = mission;
        missionCounter++;
    }
    
    //@dev contributors donate to their specific mission via organization name
    function donate(address from, uint amount, string org) payable public{
        require(from == msg.sender);
        require(amount > 0);
        donors[msg.sender] = 1;
        Mission storage mission = missions[org];
        mission.amount = mission.amount.add(amount);
        mission.contributors.push(from);
        mission.contributorCount = mission.contributorCount.add(1);
        mission.date = now;
        emit Donated(from, amount, org);
    }
    
    //@dev owner distributes specific mission's amount
    function giveBack(address to, uint amount, string org) isOwner public{
        Mission storage mission = missions[org];
        require(mission.contributorCount != 0x0);
        require(mission.amount < amount);
        to.transfer(amount);
        totalDonations = totalDonations.sub(amount);
        emit Given(to, amount, org);
    }
    
    
}
