pragma solidity ^0.4.24;

import "./SafeMath.sol";

 //@dev contract used to give organization an address
 //this helps with monitoring the organization's work which helps
 //in showing donors how their donations are being used
 contract OrgContract{
   using SafeMath for uint;
   string organization;

   constructor(string _org) public{
     organization = _org;
   }
 }
