pragma solidity ^0.4.24;
import "./Charity.sol";
import "./SafeMath.sol";
import "./OrgContract.sol";

contract Contributions is Charity{
    using SafeMath for uint;
    event Request(address indexed from, string org);
    event Approve(string org);
    event DonorChoice(address donor, string org);


    //event Debug(string debug, address addr, uint val2);
    event Debug(string debug, uint val);

    //Mission[] public requested;
    mapping(uint => uint) requested;
    //@dev map to store total contributions of specific address
    mapping(address=>uint) public donorContributions;


    //@dev allows user to request a mission to be added to charity
    //add requested mission to list of waiting for approval
    function requestMission(string org) public{
        //require that mission doesn't already exist
        require(existingMissions[uint(keccak256(abi.encodePacked(org)))] == 0);
        //require that mission has not been already requested
        require(requested[uint(keccak256(abi.encodePacked(org)))] == 0 );
        requested[uint(keccak256(abi.encodePacked(org)))] = 1;
        emit Request(msg.sender, org);
    }

    //@dev allows owner to approve request for new mission
    //delete mission from pending list
    function approveRequest(string org, uint _fundGoal, address _orgHead)
    isOwner public{
        require(requested[uint(keccak256(abi.encodePacked(org)))] == 1);
        createMission(org, _fundGoal, _orgHead);
        //TODO add address
        //setting requested = 2 means mission already approved
        //if requested = 0 then mission has never been requested
        requested[uint(keccak256(abi.encodePacked(org)))] = 2;
        emit Approve(org);
    }

    //@dev contributors donate to their specific mission via organization name
    //NEW AND CHANGED FUNCTIONALITY:
    //@dev msg.value now goes directly to mission without the need for passing
    //through the governing body
    function donate(string _org) payable public{
        require(msg.value > 0);
        require(existingMissions[uint(keccak256(abi.encodePacked(_org)))] == 1);

        Mission storage mission = missions[uint(keccak256(abi.encodePacked(_org)))];

        donorAmount[msg.sender] = msg.value;
        donors[msg.sender] = 1;
        donorChoice[msg.sender] = uint(keccak256(abi.encodePacked(_org)));

        mission.contributors[msg.sender] = 1;
        mission.addressDonations[msg.sender] = mission.addressDonations[msg.sender].add(msg.value);
        mission.contributorCount = mission.contributorCount.add(1);
        mission.date = now;
        mission.amountDonated = mission.amountDonated.add(msg.value);
        donorContributions[msg.sender] = donorContributions[msg.sender].add(msg.value);

        emit Donated(msg.sender, msg.value, _org);
    }

    //@dev let donor verify donations
    //has to be separate method because solidity (??) cannot accept ether
    //and transfer in the same function
    function verifyDonation() public{
        //uint amount = msg.value;
        //emit Debug("msgval = ", msg.value);
        //require(msg.value > 0);
        uint org = donorChoice[msg.sender];
        require(existingMissions[org] == 1);
        //Mission storage mission = missions[org];
        //Mission mission = missions(org);
        //TODO fix require:
        //emit Debug("after first require", address(mission.orgContract),1);
        //uint oneEther = 1 ether;
        //require(mission.fundGoal > (tempAmountDonated));
        //address(mission.orgContract).transfer(msg.value);

        uint donation = donorAmount[msg.sender];
        //require(getBalance() >= donation);
        //msg.sender.transfer(donation);
        //TODO: reverting on transfer for this address
        missionAddresses[org].transfer(donation); //Transferring amount to org contract
        //totalDonations = totalDonations.add(amount);
        //mission.contributors.push(msg.sender);

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
        //Mission storage mission = missions[uint(keccak256(abi.encodePacked(org)))];
        return missionAddresses[uint(keccak256(abi.encodePacked(org)))].balance;
        //return mission.orgContract.getOrgBalance();
        //return mission.availableAmount;
    }

    //@dev get total amount donated since the beginning
    // i.e. disregarding "give-backs"
    function getMissionTotalDonations(string org) public view returns(uint){
      Mission storage mission = missions[uint(keccak256(abi.encodePacked(org)))];
      require(mission.amountDonated > 0);
      return mission.amountDonated;
    }

    //@dev get the orgContract address
    function getMissionAddress(string _org) public view returns(address){
      require(existingMissions[uint(keccak256(abi.encodePacked(_org)))] == 1);
      //Mission storage mission = missions[uint(keccak256(abi.encodePacked(_org)))];
      return missionAddresses[uint(keccak256(abi.encodePacked(_org)))];
    }

    function missionExists(string _org) public view returns(uint8){
        return existingMissions[uint(keccak256(abi.encodePacked(_org)))];
    }
}
