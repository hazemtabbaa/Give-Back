pragma solidity ^0.4.24;
import "./Charity.sol";
import "./SafeMath.sol";

contract Contributions is Charity{
    using SafeMath for uint;
    event Request(address indexed from, string org);
    event Approve(string org);


    event Debug(string debug, address addr, uint val2);

    //Mission[] public requested;
    mapping(string => uint) requested;
    //@dev map to store total contributions of specific address
    mapping(address=>uint) donorContributions;

    //@dev allows user to request a mission to be added to charity
    //add requested mission to list of waiting for approval
    function requestMission(string org) public{
        //require that mission doesn't already exist
        require(existingMissions[org] == 0);
        //require that mission has not been already requested
        require(requested[org] == 0 );
        /*Mission memory pendingMission;
        pendingMission.organization = org;
        pendingMission.requester = msg.sender;
        requested[org] = pendingMission;*/
        requested[org] = 1;
        emit Request(msg.sender, org);
    }

    //@dev allows owner to approve request for new mission
    //delete mission from pending list
    function approveRequest(string org, uint _fundGoal, address _orgHead)
    isOwner public{
        createMission(org, _fundGoal, _orgHead);
        /*Mission storage mission = requested[org];
        missions[org] = mission;
        missionCounter = missionCounter.add(1);
        mission.fundGoal = _fundGoal;*/
        //TODO add address

        //setting requested = 2 means mission already approved
        //if requested = 0 then mission has never been requested
        requested[org] = 2;
        emit Approve(org);
    }

    //@dev contributors donate to their specific mission via organization name
    //NEW AND CHANGED FUNCTIONALITY:
    //@dev msg.value now goes directly to mission without the need for passing
    //through the governing body
    function donate(string org) payable public{
        uint amount = msg.value;
        //emit Debug("msgval = ", msg.value);
        require(msg.value > 0 ether);
        donors[msg.sender] = 1;
        Mission storage mission = missions[org];
        //TODO fix require:
        //Add fundgoal function or add in instantiation otherwise donate
        //will revert on require since fundGoal = 0
        //emit Debug("after first require", address(mission.orgContract),1);
        //uint oneEther = 1 ether;
        //uint tempAmountDonated = mission.amountDonated.add(amount) * oneEther;
        //emit Debug(">>>>check", mission.fundGoal,tempAmountDonated);
        //require(mission.fundGoal > (tempAmountDonated));
        address(mission.orgContract).transfer(msg.value); //Transferring amount to org contract
        //emit Debug("BALANCE", address(mission.orgContract),address(mission.orgContract).balance);
        //mission.availableAmount = mission.availableAmount.add(amount);
        //totalDonations = totalDonations.add(amount);
        //mission.contributors.push(msg.sender);
        mission.contributors[msg.sender] = 1;
        mission.addressDonations[msg.sender] = mission.addressDonations[msg.sender].add(amount);
        mission.contributorCount = mission.contributorCount.add(1);
        mission.date = now;
        mission.amountDonated = mission.amountDonated.add(amount);
        donorContributions[msg.sender] = donorContributions[msg.sender].add(msg.value);
        testAddrBalance = testAddr.balance;
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
    function getMissionBalance(string org) public view returns(uint){
        Mission storage mission = missions[org];
        return address(mission.orgContract).balance;
        //return mission.availableAmount;
    }
    //@dev get total amount donated since the beginning
    // i.e. disregarding "give-backs"
    function getMissionTotalDonations(string org) public view returns(uint){
      Mission storage mission = missions[org];
      require(mission.amountDonated > 0);
      return mission.amountDonated;
    }
}
