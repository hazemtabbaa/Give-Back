pragma solidity ^0.4.24;

import "./SafeMath.sol";
import "./Charity.sol";

 //@dev contract used to give organization an address
 //this helps with monitoring the organization's work which helps
 //in showing donors how their donations are being used
 contract OrgContract{
   using SafeMath for uint;
   string organization;
   address private orgOwner;
   string [] purchases;

   modifier isOrgOwner{
     require(msg.sender == orgOwner);
     _;
   }

   constructor(string _org, address _orgHead) public{
     organization = _org;
     orgOwner = _orgHead;
   }

   function() payable public{}

   function getOrgBalance()
    view public returns(uint){
     return address(this).balance;
   }

   //@dev allow org to record purchases without changing balance (FOR NOW)
   //due to assumption that they won't necessarily be in ETH
   //fix later when even org purchases are in ETH
   function recordPurchase(string _purchase)
    isOrgOwner public returns(bool){
     purchases.push(_purchase);
     return true;
   }

 }
