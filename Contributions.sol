pragma solidity ^0.4.19;
import "./Charity.sol";
import "./SafeMath.sol";

contract Contributions is Charity{
    using SafeMath for uint;
    
    event Request(address from, string org);
    event Approve(string org);
    
    //Mission[] public requested;
    mapping(string => Mission) requested;
    
    function requestMission(address from, string org) public{
        Mission memory pendingMission;
        pendingMission.organization = org;
        pendingMission.requester = from;
        requested[org] = pendingMission;
        emit Request(from, org);
    }
    
    function approveRequest(string org) isOwner public{
        Mission storage mission = requested[org];
        missions[org] = mission;
        delete requested[org];
        emit Approve(org);
    }
    
    //@dev contributors donate to their specific mission via organization name
    function donate(address from, uint amount, string org) payable public{
        require(from == msg.sender);
        require(amount > 0);
        donors[msg.sender] = 1;
        Mission storage mission = missions[org];
        require(mission.fundGoal < (mission.fundGoal.add(amount)));
        mission.amount = mission.amount.add(amount);
        mission.contributors.push(from);
        mission.contributorCount = mission.contributorCount.add(1);
        mission.date = now;
        emit Donated(from, amount, org);
    }
}
