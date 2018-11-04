var Charity = artifacts.require("./Charity.sol");
var Donors = artifacts.require("./Donors.sol");
var Contributions = artifacts.require("./Contributions.sol");
var SafeMath = artifacts.require("./SafeMath.sol");

module.exports = function(deployer) {
    deployer.deploy(SafeMath);
    deployer.link(SafeMath, Charity);
    deployer.deploy(Charity);
    //deployer.deploy(Charity);
    deployer.deploy(Contributions);
    deployer.deploy(Donors);
};
