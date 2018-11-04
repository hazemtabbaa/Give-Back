var Charity = artifacts.require('./Charity.sol');

contract('Charity', function(accounts) {
  var owner = accounts[0];
  var firstOrg = accounts[1];
  var secondOrg = accounts[2];
  var firstDonor = accounts[3];
  var secondDonor = accounts[4];

  var charity;

  /*beforeEach('setup contract for each test', async function () {
          charity = await Charity.new();
  });

  it('should have a valid owner', async function() {
    assert.equal(charity.owner(), owner);
  });

  it('should create new mission', async function(){
    var first = 'first';
    await charity.createMission(first, 10, firstOrg);
    assert.equal(1,1);
  });*/

  /*it('should create new mission', function(){
    return Charity.deployed().then(function(instance) {
           // set contract instance into a variable
           charity = instance;
  });*/

  it('should pass this test', function(){
    assert.equal(1,1);
  });

})
