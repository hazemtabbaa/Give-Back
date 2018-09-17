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
        //TODO add balance
        owner = msg.sender;
    }

    mapping(address=>uint8) donors;

    // @dev struct to store collection of donations given to one organization
    // and store its Impact
    struct Mission{
        //address receiver;
        address[] contributors;
        uint contributorCount;
        uint amountBalance;
        string organization;
        uint date;
        uint fundGoal;
        address requester;
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
    function createMission(string organization) isOwner public{
        Mission memory mission;
        mission.organization = organization;
        //mission.receiver = recAddress;
        missions[organization] = mission;
        missionCounter++;
    }

    //@dev owner distributes specific mission's amount
    function giveBack(address to, string org, uint amount) isOwner public{
        Mission storage mission = missions[org];
        require(mission.contributorCount != 0x0);
        require(mission.amountBalance > amount);
        require(address(this).balance >= amount);
        to.transfer(amount);
        totalDonations = totalDonations.sub(amount);
        mission.amountBalance = mission.amountBalance.sub(amount);
        emit Given(to, amount, org);
    }

    function getBalance() view public returns(uint){
        return address(this).balance;
    }


}
