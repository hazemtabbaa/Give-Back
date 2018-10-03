pragma solidity ^0.4.24;
import "./Contributions.sol";

//@contract to get information about donors/contributors
contract Donors is Contributions{
  //@dev function to check if specific address is a donor
  function isDonor(address addr) public view returns(uint8){
    if(donors[addr] == 1){
      return 1;
    }
    else{
      return 0;
    }
  }

  //@dev function to check how much specific address has donated
  function getAddressTotalDonations(address addr) public view returns(uint){
    require(donorContributions[addr] != 0);
    return donorContributions[addr];
  }

  //@dev function to check if address donated to specific missions
  function isMissionDonor(address addr, string org) public view returns(uint8){
    Mission storage mission = missions[org];
    if(mission.contributors[addr] == 1){
      return 1;
    }
    else{
      return 0;
    }
  }

  //@dev get donor's contributions to specific mission
  function getAddressToMissionDonations(address addr, string org) public view returns(uint){
    Mission storage mission = missions[org];
    require(mission.addressDonations[addr] != 0);
    return mission.addressDonations[addr];
  }




}
