var Charity = artifacts.require("./Charity.sol");
var Donors = artifacts.require("./Donors.sol");

module.exports = function(deployer) {
    deployer.deploy(Charity);
    deployer.deploy(Charity);
};
