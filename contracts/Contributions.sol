pragma solidity ^0.4.19;
import "./Charity.sol";
import "./SafeMath.sol";

contract Contributions is Charity{
    using SafeMath for uint;
    event Request(address from, string org);
    event Approve(string org);

    //Mission[] public requested;
    mapping(string => Mission) requested;

    //@dev allows user to request a mission to be added to charity
    //add requested mission to list of waiting for approval
    function requestMission(string org) public{
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
        //TODO add address
        delete requested[org];
        emit Approve(org);
    }

    //@dev contributors donate to their specific mission via organization name
    function donate( string org) payable public{
        uint amount = msg.value;
        require(amount > 0);
        donors[msg.sender] = 1;
        Mission storage mission = missions[org];
        require(mission.fundGoal < (mission.fundGoal.add(amount)));
        mission.amountBalance = mission.amountBalance.add(amount);
        totalDonations = totalDonations.add(amount);
        mission.contributors.push(msg.sender);
        mission.contributorCount = mission.contributorCount.add(1);
        mission.date = now;
        emit Donated(msg.sender, amount, org);
    }

    //@dev return mission balance
    function getMissionBalance(string org) public view returns(uint){
        Mission storage mission = missions[org];
        return mission.amountBalance;
    }
}
