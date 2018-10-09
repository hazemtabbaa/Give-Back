pragma solidity ^0.4.24;

import "./SafeMath.sol";

contract Charity{
    using SafeMath for uint;

    address private owner;
    //uint public totalDonations;
    uint public multipurposeBalance;
    uint public missionCounter;
    //uint comments;

    modifier isOwner{
        require(msg.sender == owner);
        _;
    }

    event Donated(address indexed from, uint amount, string organization);
    event Given(address indexed to, uint amount, string organization);
    event CreatedMission(string indexed org, uint fundGoal);
    event AddedFundGoal(string indexed org, uint fundGoal);

    constructor() public{
        //TODO add balance
        owner = msg.sender;
    }

    //TODO
    //maybe add mission address in struct or in createMission
    //instead of manual input of address in giveBack

    //TODO
    //fix indexed keyword in events

    //@dev map to store if address has donated or not
    mapping(address=>uint8) donors;

    // @dev struct to store collection of donations given to one organization
    // and store its Impact
    struct Mission{
        //address receiver;
        //TODO get Contributor amount
        mapping(address => uint8) contributors;
        mapping(address => uint) addressDonations;
        //address[] contributors;
        uint contributorCount;
        //amountBalance eth left in balance to give back
        uint amountBalance;
        //total amount donated disregarding "givebacks"
        uint amountDonated;
        string organization;
        uint date;
        uint fundGoal;
        //amount needed to reach fund goal
        uint toReachFundGoal;
        address requester;
    }

    mapping(string => Mission) missions;

    //@dev fallback for any donation received, used for multipurpose balance
    //TODO check if fallback should be removed
    function() payable public{
        multipurposeBalance = multipurposeBalance.add(msg.value);
        donors[msg.sender] = 1;
        emit Donated(msg.sender, msg.value, "fallback");
    }

    //@dev allows owner to create new mission with org name
    function createMission(string _organization, uint _fundGoal) isOwner public{
        Mission memory mission;
        mission.organization = _organization;
        //mission.receiver = recAddress;
        mission.fundGoal = _fundGoal;
        missions[_organization] = mission;
        missionCounter = missionCounter.add(1);
        emit CreatedMission(_organization, _fundGoal);
    }

    //@dev owner distributes specific mission's amount
    function giveBack(address to, string org, uint amount) isOwner public{
        Mission storage mission = missions[org];
        require(mission.contributorCount != 0x0);
        require(mission.amountBalance > amount);
        require(address(this).balance >= amount);
        to.transfer(amount);
        //mission.fundGoal = mission.fundGoal.sub(amount);
        mission.amountBalance = mission.amountBalance.sub(amount);
        emit Given(to, amount, org);
    }


    //@dev allow owner to change fundGoal for mission
    function addFundGoal(string _org, uint _fundGoal) isOwner public returns(uint){
       Mission storage mission = missions[_org];
       mission.fundGoal = mission.fundGoal.add(_fundGoal);
       emit AddedFundGoal(_org, _fundGoal);
       return mission.fundGoal;
    }

    function getBalance() view public returns(uint){
        return address(this).balance;
    }

    /*function getGenericDonations() view public returns(uint){
      return multipurposeBalance;
    }*/

    function donationsToFundGoal(string _org) public view returns(uint){
      Mission storage mission = missions[_org];
      return mission.toReachFundGoal;
    }


}
