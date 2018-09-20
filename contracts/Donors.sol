pragma solidity ^0.4.19;
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
  function getAddressDonations(address addr) public view returns(uint){
    return donorContributions[addr];
  }


}
