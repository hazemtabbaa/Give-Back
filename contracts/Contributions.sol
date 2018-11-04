pragma solidity ^0.4.24;
import "./Charity.sol";
import "./SafeMath.sol";

contract Contributions is Charity{
    using SafeMath for uint;
    event Request(address indexed from, string org);
    event Approve(string indexed org);

    //Mission[] public requested;
    mapping(string => Mission) requested;
    //@dev map to store total contributions of specific address
    mapping(address=>uint) donorContributions;

    //@dev allows user to request a mission to be added to charity
    //add requested mission to list of waiting for approval
    function requestMission(string org) public{
        //require that mission does not already exist
        //require(missions[org].fundGoal != 0 );
        Mission memory pendingMission;
        pendingMission.organization = org;
        pendingMission.requester = msg.sender;
        requested[org] = pendingMission;
        emit Request(msg.sender, org);
    }

    //@dev allows owner to approve request for new mission
    //delete mission from pending list
    function approveRequest(string org) isOwner public{
        Mission storage mission = requested[org];
        missions[org] = mission;
        missionCounter = missionCounter.add(1);
        //TODO add address
        delete requested[org];
        emit Approve(org);
    }

    //@dev contributors donate to their specific mission via organization name
    function donate(string org) payable public{
        uint amount = msg.value;
        require(amount > 0);
        donors[msg.sender] = 1;
        Mission storage mission = missions[org];
        //TODO fix require:
        //Add fundgoal function or add in instantiation otherwise donate
        //will revert on require since fundGoal = 0
        require(mission.fundGoal > (mission.amountDonated.add(amount)));
        mission.availableAmount = mission.availableAmount.add(amount);
        //totalDonations = totalDonations.add(amount);
        //mission.contributors.push(msg.sender);
        mission.contributors[msg.sender] = 1;
        mission.addressDonations[msg.sender] = mission.addressDonations[msg.sender].add(amount);
        mission.contributorCount = mission.contributorCount.add(1);
        mission.date = now;
        mission.amountDonated = mission.amountDonated.add(amount);
        donorContributions[msg.sender] = donorContributions[msg.sender].add(msg.value);
        emit Donated(msg.sender, amount, org);
    }

    //@dev allow donations without specific organization
    function genericDonation() payable public{
      multipurposeBalance = multipurposeBalance.add(msg.value);
      //totalDonations = totalDonations.add(msg.value);
      donors[msg.sender] = 1;
      emit Donated(msg.sender, msg.value, "generic");
    }

    //@dev return mission balance
    function getAvailableToGiveMission(string org) public view returns(uint){
        Mission storage mission = missions[org];
        return mission.availableAmount;
    }
    //@dev get total amount donated since the beginning
    // i.e. disregarding "give-backs"
    function getMissionTotalDonations(string org) public view returns(uint){
      Mission storage mission = missions[org];
      require(mission.amountDonated > 0);
      return mission.amountDonated;
    }
}
