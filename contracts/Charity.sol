pragma solidity ^0.4.24;

import "./SafeMath.sol";
import "./OrgContract.sol";

contract Charity{
    //TODO: Implement Ownable.sol
    using SafeMath for uint;

    address private owner;
    //uint public totalDonations;
    uint public multipurposeBalance;
    uint public missionCounter;
    //uint comments;
    event debugger(string test, address addr);

    modifier isOwner{
        require(msg.sender == owner);
        _;
    }

    event Donated(address indexed from, uint amount, string organization);
    event Given(uint amount, string organization);
    event CreatedMission(string org, uint fundGoal, address indexed orgHead);
    event AddedFundGoal(string org, uint fundGoal);

    constructor() public{
        //TODO add balance
        owner = msg.sender;
    }


    //@dev map to store if address has donated or not
    mapping(address=>uint8) public donors;

    //@dev mapping to store donor's current org choice
    mapping(address=>uint) public donorChoice;
    //@dev mapping to store donor's current donation amount
    mapping(address=>uint) public donorAmount;

    //@dev mapping to avoid creating duplicate missions
    mapping(uint=>uint8) public existingMissions;

    //@dev mapping to store all addresses of created orgContracts
    mapping(uint=>address) public missionAddresses;

    // @dev struct to store collection of donations given to one organization
    // and store its Impact
    struct Mission{
        //TODO get Contributor amount
        mapping(address => uint8) contributors;
        mapping(address => uint) addressDonations;
        uint contributorCount; //address[] contributors;
        uint amountDonated; //total amount donated disregarding "givebacks"
        string organization;
        uint date;
        uint fundGoal;
        address requester;
        OrgContract orgContract;
        address orgHead; //head of organization
        //address orgAddr;

    }

    //mapping(string => Mission) missions;
    mapping(uint => Mission) public missions;

    //@dev fallback for any donation received, used for multipurpose balance
    //TODO check if fallback should be removed
    function() payable public{
        multipurposeBalance = multipurposeBalance.add(msg.value);
        donors[msg.sender] = 1;
        emit Donated(msg.sender, msg.value, "fallback");
    }

    //@dev allows owner to create new mission with org name
    function createMission(string _organization, uint _fundGoal, address _orgHead)
      isOwner public{
        //prevent user from "shooting themselves in foot" by creating duplicate
        //missions
        require(existingMissions[uint(keccak256(abi.encodePacked(_organization)))] == 0);
        Mission memory mission;
        mission.organization = _organization;
        mission.orgHead = _orgHead;
        //mission.receiver = recAddress;
        //setting fundGoal to ether
        //uint oneEther = 1 ether;
        //_fundGoal = _fundGoal * oneEther;
        mission.fundGoal = _fundGoal;
        missions[uint(keccak256(abi.encodePacked(_organization)))] = mission;
        missionCounter = missionCounter.add(1);

        //Creating new address for the org
        mission.orgContract = new OrgContract(_organization, _orgHead);
        //mission.orgAddr = new OrgContract(_organization, _orgHead);
        //mission.orgAddr = address(mission.orgContract);
        //set existingMissions to 1;
        existingMissions[uint(keccak256(abi.encodePacked(_organization)))] = 1;
        missionAddresses[uint(keccak256(abi.encodePacked(_organization)))] = mission.orgContract;

        emit CreatedMission(_organization, _fundGoal, _orgHead);
    }

    //@dev owner distributes specific mission's amount
    //@dev removed address to argument
    function giveBack(string org, uint amount)
      isOwner public{
        Mission storage mission = missions[uint(keccak256(abi.encodePacked(org)))];
        require(mission.contributorCount != 0x0);
        //require(mission.availableAmount > amount);
        require(address(this).balance >= amount);
        address(mission.orgContract).transfer(amount);
        //to.transfer(amount);
        //mission.availableAmount = mission.availableAmount.sub(amount);
        emit Given(amount, org);
    }


    //@dev allow owner to change fundGoal for mission
    function addFundGoal(string _org, uint _fundGoal)
      isOwner public returns(uint){
       Mission storage mission = missions[uint(keccak256(abi.encodePacked(_org)))];
       mission.fundGoal = mission.fundGoal.add(_fundGoal);
       emit AddedFundGoal(_org, _fundGoal);
       return mission.fundGoal;
    }

    function getBalance()
      view public returns(uint){
        return address(this).balance;
    }

    /*function getGenericDonations() view public returns(uint){
      return multipurposeBalance;
    }*/

    //@dev returns amount needed to reach the fund goal
    function donationsToFundGoal(string _org)
      public view returns(uint){
      Mission storage mission = missions[uint(keccak256(abi.encodePacked(_org)))];
      return (mission.fundGoal.sub(mission.amountDonated));
    }


}
